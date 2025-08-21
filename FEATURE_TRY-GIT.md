# Feature try-git

## Use case

### Current state

  I want to try project from git. Without this feature, this is usage workflow:

  - I have GIT_URL which I want to try:

    ```
    GIT_URL: https://github.com/adam-versed/ai-assisted-workflows.git
    ```
  - run cmd: try 
  - option create, enter "ai-assisted-workflows" 
  - Go to console: `git clone {GIT_URL}`
  - because I have extra path  ~/src/tries/2025-08-21-ai-assisted-workflows/ai-assisted-workflows/README.md
  - i have to move clone source code to upper directory with

    ```
    mv * ..
    mv .* ..
    cd ..
    rm -rf ai-assisted-workflows
    ```


### try-git option

  This feature provides option to enter git repository (optionaly) and clone repos so I have code directly in try generated path:

```~/src/tries/2025-08-21-ai-assisted-workflows/```


New User interface (add `Git repository URL`):

```
📁 Try Directory Selection
────────────────────────────────────────────────────────────────────────────────────────────────────
Search:
Git repository URL (optional):
────────────────────────────────────────────────────────────────────────────────────────────────────
→ 📁 2025-08-21-try                                                                      18m ago, 6.6
  📁 2025-08-21-ai-assisted-workflows                                                    22m ago, 6.5
  + Create new
────────────────────────────────────────────────────────────────────────────────────────────────────
↑↓: Navigate  Enter: Select  ESC: Cancel
```


