# AGENTS.md

## Working agreements

- Before opening a pull request, run the superpowers code review (`superpowers:requesting-code-review`) on the PR diff: base `git merge-base origin/master HEAD`, head `HEAD`. Fix Critical and Important findings first, then put the verdict and every finding left open, with the reason, in the PR description. If the skill is unavailable, ask the user before opening the PR. There is no automatic AI review in CI.
