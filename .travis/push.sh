#!/bin/bash
setup_git() {
  git config --global user.email "keepgoingwm@gmail.com"
  git config --global user.name "keepgoingwm"
}

commit_website_files() {
  if [ $TRAVIS_EVENT_TYPE != "pull_request" ]; then
    if [ $TRAVIS_BRANCH == "master" ]; then
      echo "Committing to master branch..."
      git checkout master
      git add *
      if [ $TRAVIS_EVENT_TYPE == "cron" ]; then
        git commit --message "Travis build: $TRAVIS_BUILD_NUMBER [cron]"
      elif [ $TRAVIS_EVENT_TYPE == "api" ]; then
        git commit --message "Travis build: $TRAVIS_BUILD_NUMBER [custom]"
      else
        git reset coverage/*
        git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
      fi
    fi
  fi
}

upload_files() {
  if [ $TRAVIS_EVENT_TYPE != "pull_request" ]; then
    if [ $TRAVIS_BRANCH == "master" ]; then
      echo "Pushing to master branch..."
      git push --force --quiet "https://${GH_TOKEN}@github.com/keepgoingwm/30-seconds-of-code-cn.git" master > /dev/null 2>&1
    fi
  fi
}

setup_git
commit_website_files
upload_files
