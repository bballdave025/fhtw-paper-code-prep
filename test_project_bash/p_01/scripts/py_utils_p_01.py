"""
py_utils_p_02.py

Utility functions for experiment logging (Q&R acceptance).
"""

import json
from pathlib import Path
from datetime import datetime

# Default seed (can be overridden via env or caller)
SEED = 137

def _ts():
    """Return timestamp for filenames."""
    return datetime.now().strftime("%Y%m%dT%H%M%S")

def make_paths(seed: int = SEED, tagdir: str | Path | None = None):
    """
    Build file paths for CSV log and JSON test summary.

    Args:
        seed: random seed used for run
        tagdir: root of project (defaults to CWD or $TAGDIR)

    Returns:
        (csv_path, json_path)
    """
    tagdir = Path(tagdir or Path.cwd())
    outdir = tagdir / "outputs"
    csv_dir = outdir / "csv_logs"
    outdir.mkdir(parents=True, exist_ok=True)
    csv_dir.mkdir(parents=True, exist_ok=True)

    stamp = _ts()
    csv_path = csv_dir / f"train_history_seed{seed}_{stamp}.csv"
    json_path = outdir / f"test_summary_seed{seed}_{stamp}.json"
    return csv_path, json_path

def log_test_summary(test_acc: float,
                     loss: float | None = None,
                     seed: int = SEED,
                     tagdir: str | Path | None = None,
                     extra: dict | None = None):
    """
    Write test summary JSON and print the sentinel line.

    Args:
        test_acc: final test accuracy
        loss: optional test loss
        seed: random seed
        tagdir: project tag root
        extra: extra fields to include
    """
    _, json_path = make_paths(seed, tagdir)
    payload = {"seed": seed, "test_acc": float(test_acc)}
    if loss is not None:
        payload["test_loss"] = float(loss)
    if extra:
        payload.update(extra)

    json_path.parent.mkdir(parents=True, exist_ok=True)
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(payload, f, indent=2)

    print(f"[DONE] test_acc={payload['test_acc']:.4f}  ->  wrote {json_path}")
    return json_path

