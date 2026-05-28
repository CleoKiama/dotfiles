use rand::seq::SliceRandom;
use std::collections::VecDeque;
use std::env;
use std::path::Path;
use std::process::Command;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::Arc;
use std::time::Duration;
use walkdir::WalkDir;

const DEFAULT_INTERVAL: u64 = 600; // seconds
const DEFAULT_HISTORY: usize = 10;

fn is_file(entry: &walkdir::DirEntry) -> bool {
    entry.file_type().is_file()
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let running = Arc::new(AtomicBool::new(true));
    ctrlc::set_handler({
        let r = running.clone();
        move || {
            eprintln!("Received Ctrl-C, exiting...");
            r.store(false, Ordering::SeqCst);
        }
    })?;

    let mut args = env::args().collect::<Vec<_>>();
    let program = args.remove(0);

    if args.len() < 1 || !Path::new(&args[0]).is_dir() {
        eprintln!("Usage:\n\t{} DIRECTORY [INTERVAL]\n\tChanges the wallpaper to a randomly chosen image in DIRECTORY every\n\tINTERVAL seconds (or every {} seconds if unspecified).", program, DEFAULT_INTERVAL);
        std::process::exit(1);
    }

    let dir = args.remove(0);
    let interval = args
        .get(0)
        .and_then(|s| s.parse::<u64>().ok())
        .unwrap_or(DEFAULT_INTERVAL);

    let resize_type = "stretch";
    // respect environment variables if set
    let transition_fps = std::env::var("AWWW_TRANSITION_FPS").unwrap_or_else(|_| "30".into());
    let transition_step = std::env::var("AWWW_TRANSITION_STEP").unwrap_or_else(|_| "90".into());
    std::env::set_var("AWWW_TRANSITION_FPS", &transition_fps);
    std::env::set_var("AWWW_TRANSITION_STEP", &transition_step);

    let history_size = env::var("RECENT_HISTORY")
        .ok()
        .and_then(|s| s.parse::<usize>().ok())
        .unwrap_or(DEFAULT_HISTORY);
    let mut history: VecDeque<String> = VecDeque::with_capacity(history_size);

    let mut rng = rand::thread_rng();

    while running.load(Ordering::SeqCst) {
        let images: Vec<String> = WalkDir::new(&dir)
            .into_iter()
            .filter_map(|e| e.ok())
            .filter(is_file)
            .map(|e| e.path().display().to_string())
            .collect();

        if images.is_empty() {
            eprintln!("No files found in {}", dir);
            std::thread::sleep(Duration::from_secs(interval));
            continue;
        }

        // candidates exclude recent history
        let mut candidates: Vec<String> = images
            .iter()
            .filter(|i| !history.contains(i))
            .cloned()
            .collect();

        if candidates.is_empty() {
            // everything is in recent history; clear it to allow reuse
            history.clear();
            candidates = images.clone();
        }

        let choice = candidates.choose(&mut rng).unwrap().clone();

        eprintln!("Setting wallpaper: {}", choice);
        let status = Command::new("awww")
            .arg("img")
            .arg(format!("--resize={}", resize_type))
            .arg("--transition-type")
            .arg("simple")
            .arg(&choice)
            .status();

        match status {
            Ok(s) if s.success() => {}
            Ok(s) => eprintln!("awww exited with status: {}", s),
            Err(e) => eprintln!("Failed to run awww: {}", e),
        }

        // update history
        history.push_back(choice);
        if history.len() > history_size {
            history.pop_front();
        }

        // sleep in one-second increments so Ctrl-C can interrupt quickly
        let mut slept = 0u64;
        while slept < interval {
            if !running.load(Ordering::SeqCst) {
                break;
            }
            std::thread::sleep(Duration::from_secs(1));
            slept += 1;
        }
    }

    Ok(())
}
