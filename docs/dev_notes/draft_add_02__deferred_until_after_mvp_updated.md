Public-repository exposure audit: locate all copies of the 3,331-image labeled manifest, class-bearing filenames, and source/provenance-bearing logs across current files, Git history, branches, and related repositories; decide the intended public/private boundary; then sanitize and, if necessary, rewrite Git history before public release.

For the later audit, I’d want to search three layers:

```bah
# current working tree
grep -RInE '_(abg|cwa|fko|fmr|gni|iac|mbr|mcl|mmx|nbr|oic|orc|scg|spr|suh|tbr|ucr)(_|\.jpg|\.jpeg|\.png)' .

# all reachable Git history for suspicious filenames / class codes
git log --all --name-only --pretty=format: |
  grep -Ei 'consistentized_3331|dataset|label|classification|filename'

# inspect history content more aggressively
git rev-list --all |
while read c; do
  git grep -nE '_(abg|cwa|fko|fmr|gni|iac|mbr|mcl|mmx|nbr|oic|orc|scg|spr|suh|tbr|ucr)(_|\.jpg|\.jpeg|\.png)' "$c" -- 2>/dev/null
done
```

That last one is intentionally brute-force and may be noisy, but it answers the actual question: where in reachable history do these labels appear?

Then we do the same across your other likely repos. Only after we know the footprint should we decide whether to use git filter-repo to rewrite history.

---

And I agree that the preparation logs themselves are valuable. I would not casually delete them. They sound like they belong in the scientific record, probably near the annotation / dataset-lineage / QA documentation. The likely resolution is preserve the procedural information while separating or sanitizing any artifacts that expose the labeled manifest more directly than you intend.
