;; mostly from https://github.com/hilaolu/example-nix/blob/master/tools/spacemacs/private/direnv/packages.el
(defconst direnv-packages
  '(direnv))

(defun direnv/init-direnv ()
  (use-package direnv
    :config
    (spacemacs/declare-prefix "y" "direnv")
    (spacemacs/set-leader-keys "ye" 'direnv-edit)
    (spacemacs/set-leader-keys "yd" 'direnv-update-environment)
    (spacemacs/set-leader-keys "yu" 'direnv-update-directory-environment)))
