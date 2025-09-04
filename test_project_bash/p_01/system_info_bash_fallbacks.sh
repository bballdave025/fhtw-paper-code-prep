# Env / package managers
conda info > conda_info.txt
conda list > conda_list.txt
conda list --explicit > conda-linux-64.lock  # exact builds
command -v pip >/dev/null && pip freeze > requirements.txt

# OS + kernel
uname -a > uname.txt
( command -v lsb_release >/dev/null && lsb_release -a ) > lsb_release.txt 2>/dev/null || \
  cat /etc/os-release > os_release.txt

# CPU / memory / disk
lscpu > lscpu.txt
nproc > nproc.txt
free -h > free_h.txt
df -h . > df_h_here.txt

# Python / Jupyter
which python > which_python.txt
python -V > python_version.txt
command -v jupyter >/dev/null && jupyter --version > jupyter_version.txt
command -v jupyter >/dev/null && jupyter kernelspec list > kernelspecs.txt

# Locale (helps with encoding quirks)
locale > locale.txt

# TF / Keras relevant env knobs (if any are set)
( printenv | grep -E '^(KERAS_HOME|TF_CPP_MIN_LOG_LEVEL|OMP_NUM_THREADS|TF_NUM_(INTRA|INTER)OP_THREADS)=' ) \
  > tf_env_knobs.txt

# GPU (only if present)
command -v nvidia-smi >/dev/null && nvidia-smi -L > nvidia_gpus.txt || true
