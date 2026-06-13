# ~/.config/zsh/functions.zsh

mkcd() {
  mkdir -p "$1" && cd "$1"
}

hltkn() {
  kubectl create token headlamp --duration 24h -n headlamp | pbcopy && echo "✅ トークンをクリップボードにコピーしました" && minikube service headlamp -n headlamp
}
