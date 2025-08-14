git remote -v
git remote set-url origin https://github.com/dave-frontdev/fcc-practice.git
# 1) Start fresh
cd ~
rm -rf fcc-practice
git clone https://github.com/dave-frontdev/fcc-practice.git
cd fcc-practice
# 2) Make sure your Git identity matches GitHub (very important for the green graph)
git config user.name  "Dave-frontdev"
git config user.email "khourydave16@gmail.com"
# 3) Detect your current branch name (main vs master)
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "Branch is: $BRANCH"
# 4) Optional: confirm the remote (don't add a new origin; just set-url if needed)
git remote -v
git remote set-url origin https://github.com/dave
# If this prints help, you already have it
git filter-repo -h  >/dev/null 2>&1 || pip install git-filter-repo
# Sanity check

# 1) List commits from oldest to newest on your branch
git rev-list --reverse "$BRANCH" > commits.txt
# 2) Create the mapper script
cat > dates_map.py << 'PY'
from datetime import datetime, timedelta, timezone
import sys

# Config — adjust i6 o2u want
START_STR = "2025-05-01 10:00 +0300"
END_STR   = "2025-07-31 18:00 +0300"

def parse_dt(s: str) -> datetime:
    # s like "YYYY-MM-DD HH:MM +0300"
    dt = datetime.strptime(s[:-6], "%Y-%m-%d %H:%M")
    sign = 1 if s[-5] == '+' else -1
    hh = int(s[-5:-3])
    mm = int(s[-2:])
    tz = timezone(sign * timedelta(hours=hh, minutes=mm))
    return dt.replace(tzinfo=tz)

start = parse_dt(START_STR)
end   = parse_dt(END_STR)
if end <= start:
    print("END must be after START", file=sys.stderr)
    sys.exit(1)

# Read SHAs
with open("commits.txt","r",encoding="utf-8") as f:
    shas = [line.strip() for line in f if line.strip()]

N = len(shas)
if N == 0:
    print("No commits found. Are you on the right branch?", file=sys.stderr)
    sys.exit(1)

# Spread timestamps linearly from start..end
span = (end - start)
out = []
for i, sha in enumerate(shas):
    if N == 1:
        t = start
    else:
        t = start + span * (i / (N - 1))
    # Round to nearest minute to keep it neat
    t = t.replace(second=0, microsecond=0)
    # Format: "YYYY-MM-DD HH:MM +0300" style
    z = t.strftime("%z"
    out.append(f"{sha}|{t.strftime('%Y-%m-%d %H:%M')} {z[:3]}{z[3:]}")

with open("map.txt","w",encoding="utf-8") as f:

    f.write("\n".join(out))

print(f"Wrote map.txt with {len(out)} lines spanning {START_STR} .. {END_STR}")

PY

# 1) List commits from oldest to newest on your branch
git rev-list --reverse "$BRANCH" > commits.txt
# 2) Create the mapper script
cat > dates_map.py << 'PY'
from datetime import datetime, timedelta, timezone
import sys

# Config — adjust if you want
START_STR = "2025-05-01 10:00 +0300"
END_STR   = "2025-07-31 18:00 +0300"

def parse_dt(s: str) -> datetime:
    # s like "YYYY-MM-DD HH:MM +0300"
    dt = datetime.strptime(s[:-6], "%Y-%m-%d %H:%M")
    sign = 1 if s[-5] == '+' else -1
    hh = int(s[-5:-3])
    mm = int(s[-2:])
    tz = timezone(sign * timedelta(hours=hh, minutes=mm))
    return dt.replace(tzinfo=tz)

start = parse_dt(START_STR)
end   = parse_dt(END_STR)
if end <= start:
    print("END must be after START", file=sys.stderr)
    sys.exit(1)

# Read SHAs
with open("commits.txt","r",encoding="utf-8") as f:
    shas = [line.strip() for line in f if line.strip()]

N = len(shas)
if N == 0:
    print("No commits found. Are you on the right branch?", file=sys.stderr)
    sys.exit(1)

# Spread timestamps linearly from start..end
span = (end - start)
out = []
for i, sha in enumerate(shas):
    if N == 1:
        t = start
    else:
        t = start + span * (i / (N - 1))
    # Round to nearest minute to keep it neat
    t = t.replace(second=0, microsecond=0)
    # Format: "YYYY-MM-DD HH:MM +0300" style
    z = t.strftime("%z")
    out.append(f"{sha}|{t.strftime('%Y-%m-%d %H:%M')} {z[:3]}{z[3:]}")

with open("map.txt","w",encoding="utf-8") as f:
    f.write("\n".join(out))

print(f"Wrote map.txt with {len(out)} lines spanning {START_STR} .. {END_STR}")
PY

python dates_map.py
# 1) List commits from oldest to newest on your branch
git rev-list --reverse "$BRANCH" > commits.txt
# 2) Create the mapper script
cat > dates_map.py << 'PY'
from datetime import datetime, timedelta, timezone
import sys


# Config — adjust if you want
START_STR = "2025-05-01 10:00 +0300"
END_STR   = "2025-07-31 18:00 +0300"


def parse_dt(s: str) -> datetime:
    # s like "YYYY-MM-DD HH:MM +0300"
    dt = datetime.strptime(s[:-6], "%Y-%m-%d %H:%M")
    sign = 1 if s[-5] == '+' else -1
    hh = int(s[-5:-3])
    mm = int(s[-2:])
    tz = timezone(sign * timedelta(hours=hh, minutes=mm))
    return dt.replace(tzinfo=tz)
start = parse_dt(START_STR)
end   = parse_dt(END_STR)
if end <= start:
    print("END must be after START", file=sys.stderr)
    sys.exit(1)

# Read SHAs
with open("commits.txt","r",encoding="utf-8") as f:
    shas = [line.strip() for line in f if line.strip()]

N = len(shas)
if N == 0:
    print("No commits found. Are you on the right branch?", file=sys.stderr)
    sys.exit(1)

# Spread timestamps linearly from start..end
span = (end - start)
out = []
for i, sha in enumerate(shas):
    if N == 1:
        t = start
    else:
        t = start + span * (i / (N - 1))
    # Round to nearest minute to keep it neat
    t = t.replace(second=0, microsecond=0)
    # Format: "YYYY-MM-DD HH:MM +0300" style
    z = t.strftime("%z")
    out.append(f"{sha}|{t.strftime('%Y-%m-%d %H:%M')} {z[:3]}{z[3:]}")

with open("map.txt","w",encoding="utf-8") as f:
    f.write("\n".join(out))

print(f"Wrote map.txt with {len(out)} lines spanning {START_STR} .. {END_STR}")
PY

python dates_map.py
# 1) Create the git filter-repo callback
cat > callback.py << 'PY'
mapping = {}
with open("map.txt","r",encoding="utf-8") as f:
    for line in f:
        sha, date = line.strip().split("|", 1)
        mapping[sha.lower()] = date

def commit_callback(commit):
    sha = commit.original_id.hex().lower()
    d = mapping.get(sha)
    if d:
        d_bytes = d.encode("utf-8")
        commit.author_date = d_bytes
        commit.committer_date = d_bytes
PY

# 2) Rewrite locally (history will change!)
git filter-repo --force --commit-callback callback.py
# 3) Push rewritten history
git push --force-with-lease origin "$BRANCH"
git branch -a
git checkout main 2>/dev/null || git checkout master
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
git config user.email "the-email-listed-in-GitHub-Settings->Emails"
# If you had the wrong email, re-run steps C+D so each commit contains the correct author email.
git remote set-url origin https://github.com/dave-frontdev/fcc-practice.git
pip install git-filter-repo
# then reopen Git Bash and try again
# ==== A) Fresh start ====
cd ~
rm -rf fcc-practice
git clone https://github.com/dave-frontdev/fcc-practice.git
cd fcc-practice
# Make sure your Git identity matches GitHub (needed for green graph)
git config user.name  "Your Name"
git config user.email "your-email-on-github@example.com"
# Detect current branch (main vs master)
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "Branch is: $BRANCH"
# ==== B) Install git-filter-repo (if not present) ====
git filter-repo -h >/dev/null 2>&1 || pip install git-filter-repo
git filter-repo -h >/dev/null && echo "git-filter-repo OK"
# ==== C) Generate date mapping (June 1 → July 15) ====
# 1) Oldest→newest commit list for your branch
git rev-list --reverse "$BRANCH" > commits.txt
# 2) Create a Python script to spread commits linearly across the window
cat > dates_map.py << 'PY'
from datetime import datetime, timedelta, timezone

# ---- Config: change these if you want different bounds/times ----
START_STR = "2025-06-01 10:00 +0300"  # start of June
END_STR   = "2025-07-15 18:00 +0300"  # mid July
# -----------------------------------------------------------------

def parse_dt(s: str) -> datetime:
    # "YYYY-MM-DD HH:MM +ZZZZ"
    dt = datetime.strptime(s[:-6], "%Y-%m-%d %H:%M")
    sign = 1 if s[-5] == '+' else -1
    hh = int(s[-5:-3]); mm = int(s[-2:])
    return dt.replace(tzinfo=timezone(sign * timedelta(hours=hh, minutes=mm)))

start = parse_dt(START_STR)
end   = parse_dt(END_STR)
if end <= start:
    raise SystemExit("END must be after START")

with open("commits.txt","r",encoding="utf-8") as f:
    shas = [line.strip() for line in f if line.strip()]

if not shas:
    raise SystemExit("No commits found. Are you on the right branch?")

N = len(shas)
span = (end - start)

out_lines = []
for i, sha in enumerate(shas):
    t = start if N == 1 else start + span * (i/(N-1))
    t = t.replace(second=0, microsecond=0)  # neat minutes
    out_lines.append(f"{sha}|{t.strftime('%Y-%m-%d %H:%M %z')}")

with open("map.txt","w",encoding="utf-8") as f:
    f.write("\n".join(out_lines))

print(f"Wrote map.txt for {N} commits spanning {START_STR} .. {END_STR}")
PY

python dates_map.py
# Peek at first/last lines (optional)
head -3 map.txt
tail -3 map.txt
# ==== D) Rewrite commit dates (author + committer) ====
cat > callback.py << 'PY'
mapping = {}
with open("map.txt","r",encoding="utf-8") as f:
    for line in f:
        sha, date = line.strip().split("|", 1)
        mapping[sha.lower()] = date

def commit_callback(commit):
    sha = commit.original_id.hex().lower()
    d = mapping.get(sha)
    if d:
        db = d.encode("utf-8")
        commit.author_date = db
        commit.committer_date = db
PY

# history rewrite happens here
git filter-repo --force --commit-callback callback.py
# ==== E) Push the rewritten history ====
git checkout "$BRANCH"
git remote set-url origin https://github.com/dave-frontdev/fcc-practice.git
# ==== Fresh clone ====
cd ~
rm -rf fcc-practice
git clone https://github.com/dave-frontdev/fcc-practice.git
cd fcc-practice
# ==== Identity (must match a verified email on your GitHub) ====
git config user.name  "dave-frontdev"
git config user.email "khourydave16@gmail.com"
# Detect active branch (main/master)
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "Branch is: $BRANCH"
# ==== Install git-filter-repo if missing ====
git filter-repo -h >/dev/null 2>&1 || pip install git-filter-repo
git filter-repo -h >/dev/null && echo "git-filter-repo OK"
# ==== Generate date mapping (June 1 -> July 15, +0300) ====
git rev-list --reverse "$BRANCH" > commits.txt
cat > dates_map.py << 'PY'
from datetime import datetime, timedelta, timezone
START_STR = "2025-06-01 10:00 +0300"
END_STR   = "2025-07-15 18:00 +0300"

def parse_dt(s: str) -> datetime:
    dt = datetime.strptime(s[:-6], "%Y-%m-%d %H:%M")
    sign = 1 if s[-5] == '+' else -1
    hh = int(s[-5:-3]); mm = int(s[-2:])
    return dt.replace(tzinfo=timezone(sign * timedelta(hours=hh, minutes=mm)))

start = parse_dt(START_STR); end = parse_dt(END_STR)
with open("commits.txt","r",encoding="utf-8") as f:
    shas = [x.strip() for x in f if x.strip()]
if not shas: raise SystemExit("No commits found.")
N = len(shas); span = (end - start)

lines = []
for i, sha in enumerate(shas):
    t = start if N == 1 else start + span * (i/(N-1))
    t = t.replace(second=0, microsecond=0)
    lines.append(f"{sha}|{t.strftime('%Y-%m-%d %H:%M %z')}")
open("map.txt","w",encoding="utf-8").write("\n".join(lines))
print(f"Wrote map.txt for {N} commits spanning {START_STR} .. {END_STR}")
PY

python dates_map.py
# (optional) quick peek
head -3 map.txt; tail -3 map.txt
# ==== Rewrite commit dates (author + committer) ====
cat > callback.py << 'PY'
mapping = {}
with open("map.txt","r",encoding="utf-8") as f:
    for line in f:
        sha, date = line.strip().split("|", 1)
        mapping[sha.lower()] = date
def commit_callback(commit):
    sha = commit.original_id.hex().lower()
    d = mapping.get(sha)
    if d:
        b = d.encode("utf-8")
        commit.author_date = b
        commit.committer_date = b
PY

git filter-repo --force --commit-callback callback.py
# ==== Push rewritten history ====
git checkout "$BRANCH"
git remote set-url origin https://github.com/dave-frontdev/fcc-practice.git
git push --force-with-lease origin "$BRANCH"
echo "Done. Commits now fall between 2025-06-01 and 2025-07-15 (+0300)."
git log --pretty=format:"%h %ad %an" --date=iso | head -10
git push --force-with-lease origin $(git rev-parse --abbrev-ref HEAD)
git log --pretty=format:"%h %ad %an" --date=iso | head -10
# ==== 0) Fresh clone ====
cd ~
rm -rf fcc-practice
git clone https://github.com/dave-frontdev/fcc-practice.git
cd fcc-practice
# Your identity (for the green graph)
git config user.name  "dave-frontdev"
git config user.email "khourydave16@gmail.com"
# Detect branch (main/master)
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
echo "Branch is: $BRANCH"
# ==== 1) Ensure git-filter-repo is available ====
git filter-repo -h >/dev/null 2>&1 || pip install git-filter-repo
git filter-repo -h >/dev/null || { echo "git-filter-repo not installed. Reopen Git Bash and retry."; exit 1; }
echo "git-filter-repo OK"
# ==== 2) Build commit list (oldest -> newest) ====
git rev-list --reverse "$BRANCH" > commits.txt
echo "Commit count: $(wc -l < commits.txt)"
head -3 commits.txt; tail -3 commits.txt
# ==== 3) Generate date mapping: 2025-06-01 .. 2025-07-15 (+0300) ====
cat > dates_map.py << 'PY'
from datetime import datetime, timedelta, timezone
START_STR = "2025-06-01 10:00 +0300"
END_STR   = "2025-07-15 18:00 +0300"

def parse_dt(s: str) -> datetime:
    dt = datetime.strptime(s[:-6], "%Y-%m-%d %H:%M")
    sign = 1 if s[-5] == '+' else -1
    hh = int(s[-5:-3]); mm = int(s[-2:])
    return dt.replace(tzinfo=timezone(sign * timedelta(hours=hh, minutes=mm)))

start, end = parse_dt(START_STR), parse_dt(END_STR)
shas = [l.strip() for l in open("commits.txt","r",encoding="utf-8") if l.strip()]
assert shas, "No commits found."
N = len(shas)
span = (end - start)

lines = []
for i, sha in enumerate(shas):
    t = start if N == 1 else start + span * (i/(N-1))
    t = t.replace(second=0, microsecond=0)
    lines.append(f"{sha}|{t.strftime('%Y-%m-%d %H:%M %z')}")
open("map.txt","w",encoding="utf-8").write("\n".join(lines))
print(f"map.txt written for {N} commits from {START_STR} to {END_STR}")
PY

python dates_map.py
echo "Preview of map:"
head -3 map.txt; tail -3 map.txt
# ==== 4) Rewrite: set dates AND author/committer identity on every commit ====
cat > callback.py << 'PY'
AUTHOR_NAME = b"dave-frontdev"
AUTHOR_EMAIL = b"khourydave16@gmail.com"

mapping = {}
with open("map.txt","r",encoding="utf-8") as f:
    for line in f:
        sha, date = line.strip().split("|", 1)
        mapping[sha.lower()] = date.encode("utf-8")

def commit_callback(commit):
    sha = commit.original_id.hex().lower()
    d = mapping.get(sha)
    if d:
        commit.author_date = d
        commit.committer_date = d
    # Stamp identity to ensure GitHub counts them
    commit.author_name = AUTHOR_NAME
    commit.author_email = AUTHOR_EMAIL
    commit.committer_name = AUTHOR_NAME
    commit.committer_email = AUTHOR_EMAIL
PY

# IMPORTANT: run the rewrite (you'll see a summary)
git filter-repo --force --commit-callback callback.py
# ==== 5) Verify locally BEFORE pushing ====
echo
echo "Top 5 commits after rewrite:"
git log --pretty=format:"%h %ad %an <%ae>" --date=iso | head -5
echo
echo "Bottom (oldest) 5 commits after rewrite:"
git log --reverse --pretty=format:"%h %ad %an <%ae>" --date=iso | head -5
# ==== 6) Push rewritten history ====
git remote set-url origin https://github.com/dave-frontdev/fcc-practice.git
git push --force-with-lease origin "$BRANCH"
echo "Done. Check GitHub commits + your contribution graph."
git rev-parse --abbrev-ref HEAD
wc -l commits.txt && head -3 commits.txt && tail -3 commits.txt
git log --pretty=format:"%h %ad %an <%ae>" --date=iso | head -10
# Start an interactive rebase from the very first commit
git rebase -i --root
git rebase -i --root
# Start an interactive rebase from the very first commit
git rebase -i --root
# Start an interactive rebase from the very first commit
git rebase -i --root
cd ~/fcc-practice
git status
[200~
node -v
npm -v
git clone <YOUR-REPO-URL>
cd <YOUR-FOLDER>
npm ci
code .
node -v
git rev-parse --is-inside-work-tree 2>/dev/null || (git init && git add . && git commit -m "chore: bootstrap app" && git branch -M main)
$ git config --global user.name "Dave Khoury"
$ git config --global user.email "khourydave16@gmail.com"
git config --global --list
\$ git config --global core.editor "code --wait"
\\wqd
$ git config --global core.editor "code --wait"
$ git init my-project
$ git init my-project
Initialized empty Git repository in C:\Users\Admin\Desktop\Davos\UA\Sems\InternshipFiles\schedex-frontend\fcc-practice
Initialized empty Git repository in https://github.com/dave-frontdev/fcc-practice.git
$ git init my-project
$ git pull origin main
$ code file-name  # For example, code index.html
$ git status  # On branch master
git --version
git init
Initialized empty Git repository in C:\Users\Admin\Desktop\Git and Github tutorialC:\Users\Admin\Desktop\Git and Github tutorial/.git/
git init
git init
