import sys
import importlib
import psutil
from ptflops import get_model_complexity_info
from torchvision.models import resnet18

# -------------------------
# Package Checks, part 1
# -------------------------
# List of packages to check
packages = {
  "Python": sys.version,
  "tensorflow": "tensorflow",
  "torch": "torch",
  "torchvision": "torchvision",
  "torchaudio": "torchaudio",
  "numpy": "numpy",
  "pandas": "pandas",
  "scikit-learn": "sklearn",
  "opencv": "cv2",
  "Pillow": "PIL",
  "matplotlib": "matplotlib",
  "tensorboard": "tensorboard",
  "visualkeras": "visualkeras",
  "netron": "netron",
  "ptflops": "ptflops",
  "psutil": "psutil",
  "tqdm": "tqdm",
  "humanfriendly": "humanfriendly",
  "sagemaker": "sagemaker",
  "boto3": "boto3",
  "jupyterlab": "jupyterlab",
  "jsonschema": "jsonschema",
}

# -------------------------
# Package Checks, part 2
# -------------------------
def check_package(pkg_name, module_name):
  try:
    module = importlib.import_module(module_name)
    version = getattr(module, "__version__", "Unknown")
    print(f"[OK] {pkg_name} - version: {version}")
  except ImportError:
    print(f"[MISSING] {pkg_name} - not installed")
  finally:
    print(f"Finished check_package for {pkg_name} ({module_name})")
    print()
  ##endof:  try/except/finally <import and get attributes>
##endof:  def check_package


# -------------------------
# GPU Checks
# ------------------------
def check_gpu():
  print("\nGPU Check:")
  print("=" * 20)
    
    # TensorFlow GPU
  try:
    import tensorflow as tf
    gpus = tf.config.list_physical_devices('GPU')
    if gpus:
      print(f"[TF GPU] TensorFlow sees {len(gpus)} GPU(s): {[gpu.name for gpu in gpus]}")
    else:
      print("[TF GPU] No GPU detected for TensorFlow.")
  except ImportError:
    print("[TF GPU] TensorFlow not installed, cannot check GPU.")
  finally:
    print("Finished Tensorflow GPU part of check_gpu")
    print()
  ##endof:  try/except/finally <tensorflow gpu stuff>
  
    # PyTorch GPU
  try:
    import torch
    if torch.cuda.is_available():
      print(f"[Torch GPU] PyTorch sees {torch.cuda.device_count()} " + \
            f"GPU(s): {torch.cuda.get_device_name(0)}")
    else:
      print("[Torch GPU] No GPU detected for PyTorch.")
  except ImportError:
    print("[Torch GPU] PyTorch not installed, cannot check GPU.")
  finally:
    print("Finished PyTorch GPU part of check_gpu")
    print()
  ##endof:  try/except/finally <pytorch gpu stuff>
##endof:  def check_gpu

# -------------------------
# Memory and FLOPs Tests
# -------------------------
def check_memory_flops():
  print("\nMemory and FLOPs Test:")
  print("="*20)
  mem = psutil.virtual_memory()
  print(f"Total RAM: {mem.total/1e9:.2f} GB, Available: {mem.available/1e9:.2f} GB")
  # Small FLOPs test using ResNet18
  try:
    macs, params = get_model_complexity_info(
        resnet18(), 
        (3, 224, 224), 
        as_strings=True,
        print_per_layer_stat=False, 
        verbose=False
    )
    print(f"ResNet18 Params: {params}, FLOPs: {macs}")
  except Exception as e:
    print(f"ptflops test failed: {e}")
  finally:
    print("Finished check_memory_flops")
    print()
  ##endof:  try/except/finally <get_model_complexity_info>
##endof:  check_memory_flops

# -------------------------
# Main
# -------------------------
if __name__ == "__main__":
  '''
  Gets called when validate_env.py is called from the command line
  '''
  
  print("Environment Validation Report:")
  print("=" * 40)
  for name, mod in packages.items():
    if name == "Python":
      print(f"Python - version: {mod}")
    else:
      check_package(name, mod)
    ##endof:  if/else <python>
    
  check_gpu()
  check_memory_flops()
##endof:  if __name__ == "__main__"
