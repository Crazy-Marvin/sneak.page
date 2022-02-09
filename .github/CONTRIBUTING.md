# Setup

### 🐧 Linux
- [Install Elm](https://github.com/elm/compiler/blob/master/installers/linux/README.md)

  - curl -L -o elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz

  - gunzip elm.gz

  - chmod +x elm

  - sudo mv elm /usr/local/bin/

- Install [Visual Studio Code](https://code.visualstudio.com/)

  - sudo snap install code --classic

  - Enable the ```elmtooling.elm-ls-vscode``` extension

  - sudo apt install npm

  - sudo npm install -g elm-test elm-format elm-review

### Gitpod

- Go to [https://gitpod.io/#https://github.com/Crazy-Marvin/sneak.page](https://gitpod.io/#https://github.com/Crazy-Marvin/sneak.page)
- Run `npx install -g elm elm-test elm-format`
- Always add `npx` before a command which you wouldn't do locally (e.g. `npx elm reactor` instead of `elm reactor`)


### Windows

 - [Install Elm](https://github.com/elm/compiler/releases/download/0.19.1/installer-for-windows.exe)
    - Put the ```elm-format.exe``` from [avh4/elm-format](https://github.com/avh4/elm-format/releases) into ```C:\Program Files (x86)\Elm\0.19.1\bin```
 - Install [Visual Studio Code](https://code.visualstudio.com/) 
    - Enable the ```elmtooling.elm-ls-vscode``` extension

# Secrets

Secrets (primarily API keys) are handled within GitHub directly.

[`TMDB`](https://developers.themoviedb.org/3/getting-started/introduction): you can get one from https://developers.themoviedb.org/   
[`CODECOV_TOKEN`](https://about.codecov.io/): this comes from Codecov  
[`LHCI_GITHUB_APP_TOKEN`](https://github.com/treosh/lighthouse-ci-action): this comes from the GitHub Action  
![key](https://user-images.githubusercontent.com/15004217/153264623-1ed3afb6-3a68-4db8-9900-46fa397ed35a.PNG)

# Running

elm reactor

# CI & tests

GitHub Actions

# Deployment

Hosting: GitHub Pages
Backend: Supabase

Secrets are stored on GitHub

# Bug Reports

Use the template

# Feature Request

Use the template

# Security Vulnerabilities

E-Mail

# Support

E-Mail

