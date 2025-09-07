I found it very quickly, otherwise I just would have gone with the model you gave above. I don't think we need all of this; I think just `build_model()` and some lines to use it will do.


Minimal CIFAR-10 cell (paste into the notebook and run) 

```
# Minimal CIFAR-10 train+test (seed=137, CPU-friendly) 
import os, random, json, csv 
from datetime import datetime 
import numpy as np 
import tensorflow as tf 
from tensorflow.keras import layers, Model 

def set_seed(seed: int = 137) -> None:
  """ 
  Set best-effort deterministic seeds for Python, NumPy, and TensorFlow. 
  """ 
  os.environ["PYTHONHASHSEED"] = str(seed) 
  random.seed(seed) 
  np.random.seed(seed) 
  tf.random.set_seed(seed) 
  set_seed(137) 

def load_cifar10() -> tuple[tuple[np.ndarray, np.ndarray], tuple[np.ndarray, np.ndarray]]: 
  """ 
  Load CIFAR-10, normalize to [0,1], and squeeze labels to shape (N,). 
  """ 
  (x_tr, y_tr), (x_te, y_te) = tf.keras.datasets.cifar10.load_data() 
  x_tr = (x_tr.astype("float32") / 255.0) 
  x_te = (x_te.astype("float32") / 255.0) 
  y_tr = y_tr.reshape(-1) 
  y_te = y_te.reshape(-1) 
  return (x_tr, y_tr), (x_te, y_te) 

def build_model(input_shape=(32, 32, 3), n_classes: int = 10) -> Model: 
  """ 
  Tiny A0-style CNN with named layers; logits output (no softmax in the layer). 
  """ 
  inputs = layers.Input(shape=input_shape) 
  x = layers.Conv2D(32, 3, padding="same", activation="relu", name="conv1")(inputs) 
  x = layers.MaxPooling2D()(x) 
  x = layers.Conv2D(64, 3, padding="same", activation="relu", name="conv2")(x) 
  x = layers.MaxPooling2D()(x) 
  x = layers.Conv2D(64, 3, padding="same", activation="relu", name="conv3")(x) 
  x = layers.Flatten()(x) x = layers.Dense(64, activation="relu")(x) 
  outputs = layers.Dense(n_classes, name="logits")(x) 
  return Model(inputs, outputs, name="A0_CNN") 

def train_and_eval(epochs: int = 4, batch_size: int = 128) -> dict: 
  """ 
  Train for a few epochs; return metrics and write simple artifacts under ../outputs/. 
  """ 
  (x_tr, y_tr), (x_te, y_te) = load_cifar10() model = build_model() 
  model.compile(optimizer=tf.keras.optimizers.Adam(1e-3), 
  loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True), metrics=["accuracy"], ) 
  hist = model.fit(x_tr, y_tr, validation_split=0.1, epochs=epochs, batch_size=batch_size, verbose=2, )
   te_loss, te_acc = model.evaluate(x_te, y_te, verbose=0) 
  ts = datetime.now().strftime("%Y%m%d-%H%M%S") 
  out_dir = os.path.normpath(os.path.join(os.getcwd(), "..", "outputs")) 
  logs_dir = os.path.join(out_dir, "csv_logs") 
  os.makedirs(logs_dir, exist_ok=True) 
  csv_path = os.path.join(logs_dir, f"train_history_seed137_{ts}.csv") 
  with open(csv_path, "w", newline="") as f:
    w = csv.writer(f) 
    w.writerow(["epoch", "loss", "accuracy", "val_loss", "val_accuracy"]) 
    for i in range(len(hist.history["loss"])): 
      w.writerow([i + 1, float(hist.history["loss"][i]), float(hist.history["accuracy"][i]), float(hist.history["val_loss"][i]), float(hist.history["val_accuracy"][i]), ]) 
  summary = {"seed": 137, "epochs": epochs, "test_loss": float(te_loss), "test_accuracy": float(te_acc)} 
  json_path = os.path.join(out_dir, f"test_summary_seed137_{ts}.json") 
  with open(json_path, "w") as f: 
    json.dump(summary, f, indent=2) 
  print(f"[DONE] test_acc={te_acc:.4f} artifacts:") 
  print(f" - {csv_path}") print(f" - {json_path}") 
  return summary 


summary = train_and_eval(epochs=4, batch_size=128) 
summary 
```


<hr/> 


Artifacts to expect 
- p_01/outputs/csv_logs/train_history_seed137_<ts>.csv 
- p_01/outputs/test_summary_seed137_<ts>.json 


<hr/> 


Commit & push 

```
git add -A 
git commit -m "Linux Q&R: CIFAR10 quick run (seed=137), artifacts saved" 
git push
```


Scaffolder tweak so that every new tag auto-drops an empty __init__.py in its own directory as well as in its `scripts`, also putting un a py_utils_<tag>.py skeleton.



# CIFAR-10 E2E Baseline → Local or AWS
_Date: 2025-09-06_

## Modes & Paths
- Choose one: E2E_LOCAL or AWS_TRY_1
- Repo root: ~/my_repos_dwb/fhtw-paper-code-prep/
- Tag dir (E2E Local): test_project_bash/p_03_e2e/
- Tag dir (AWS Try 1): aws_s3_cifar/transfer_try_1/

## TL;DR (Q&R)
Produce:
- Notebook prints: [DONE] test_acc=...
- Files under outputs/:
  - csv_logs/train_history_seed137_<ts>.csv
  - test_summary_seed137_<ts>.json

## Environment
- Conda env: vanilla_cnn   Kernel: Python (vanilla_cnn)
- Threads/env (before TF import):
  OMP_NUM_THREADS=4
  TF_NUM_INTEROP_THREADS=2
  TF_NUM_INTRAOP_THREADS=4
  CUDA_VISIBLE_DEVICES=""  (CPU acceptable)

## Dataset Cache Fallback
- Project-scoped Keras cache: $TAGDIR/datasets
- If empty, seed from ~/.keras/datasets

## Pathing in Notebooks (imports work both ways)

```python
import sys, os
from pathlib import Path
tagdir = Path(os.environ["TAGDIR"])
pkg_parent = tagdir.parent
for p in (tagdir, pkg_parent):
  sp = str(p)
  if sp not in sys.path:
  sys.path.insert(0, sp)
```

## Run Checklist
1. JupyterLab at tag dir
   - Local: cd ~/my_repos_dwb/fhtw-paper-code-prep/test_project_bash/p_03_e2e
   - AWS:   cd ~/my_repos_dwb/fhtw-paper-code-prep/aws_s3_cifar/transfer_try_1
   - Launch: start_cifar_lab.sh -e vanilla_cnn -k
2. Notebook: open notebooks/02_training.ipynb
3. Bootstrap cell: set env, TAGDIR, outputs/, include log_test_summary
4. Train → Eval → Log

```python
test_loss, test_acc = model.evaluate(test_ds, verbose=0)
from scripts.py_utils_<tag> import log_test_summary
log_test_summary(test_acc, loss=float(test_loss), seed=137, tagdir=os.environ["TAGDIR"])
```

5. Verify artifacts: [DONE] printed, CSV+JSON in outputs/

## Notes
- If JSON/CSV land under notebooks/outputs/, pass tagdir explicitly.
- Jupyter tip: --ServerApp.default_url='/lab/tree/notebooks/' lands you in the right folder.

## AWS Scaffolding (bash for structure.sh)

```bash
scaffold_tag () {
local EXP="${1:?experiment required}"
local TAG="${2:?tag required}"
local ROOT="${ROOT_DIR:-$HOME/my_repos_dwb/fhtw-paper-code-prep}"
local TAGDIR="$ROOT/$EXP/$TAG"
mkdir -p "$TAGDIR"/{notebooks,scripts,outputs/{csv_logs,gradcam_images},datasets,models,logs,visualizations}
: > "$TAGDIR/init.py"
: > "$TAGDIR/scripts/init.py"
local UTILS="$TAGDIR/scripts/py_utils_${TAG}.py"
if [[ ! -f "$UTILS" ]]; then
echo '"""Per-tag utils."""' > "$UTILS"
fi
echo "Scaffolded: $TAGDIR"
}
```

Usage:

```
export ROOT_DIR="$HOME/my_repos_dwb/fhtw-paper-code-prep"
scaffold_tag aws_s3_cifar transfer_try_1
scaffold_tag test_project_bash p_03_e2e
```

---

FIRST PROMPT FOR NEW CHAT:
"Let’s start from this CIFAR-10 E2E baseline context. Goal: run a local dry-run in tag p_03_e2e with guardrails {Timebox 60–90 min, Reuse only, Deliverables = [DONE] test_acc=..., CSV+JSON in outputs/, Exit if blocker >15 min}. Then prepare AWS scaffolding for transfer_try_1."
