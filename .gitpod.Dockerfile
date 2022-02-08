FROM gitpod/workspace-full

USER gitpod

RUN npx install -g elm elm-test elm-format
