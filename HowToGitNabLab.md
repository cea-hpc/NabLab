# How to make a contribute to NabLab project with Git


1. Create a fork of NabLab project:
-----------------------------------
- go to https://github.com/cea-hpc/NabLab and click **fork** button
- you will now have your own reporisoty of NabLab (typically https://github.com/contributor/NabLab.git)


2. Setup (optionnal):
---------------------
- Publish changes to your fork by default (named **origin**):

`git config remote.pushdefault origin`

- Use the same name of current branch to publish changes to repo:

`git config push.default current`



3. Set reference:
-----------------
- Add main NabLab repo (will be named **upstream**) as reference:

`git remote add upstream https://github.com/cea-hpc/NabLab.git`

- Make your fork up to date:

`git fetch upstream`

`git pull upstream master`


4. Create a branch to work (optionnal):
---------------------------------------
- Our *contribution* branch will automatically track the upstream/master branch:

`git checkout -b contribution upstream/master`


5. Do your stuff:
-----------------
- add, commit, ...


6. Publish your contribution:
-----------------------------
- If you've follow the 2. Setup, just

`git push`

- Now go to web interface and ask for a **pull-request**


7. If you need to fix your code:
--------------------------------
- `git add --update`
- `git commit`
- `git push`


8. Updated upstream just before your pull-request:
--------------------------------------------------
- If the reference is updated before your pull request is accepted, you can rebase your branch:

`git pull --rebase`

`git push --force-with-lease`
