#!/bin/bash

# export and clean up ready-to-apply ArgoCD app and project manifests to a respective file
# uses krew plugin: kubectl-neat to clean up manifest output https://github.com/itaysk/kubectl-neat
# krew install https://krew.sigs.k8s.io/docs/user-guide/setup/install/
# may need to make this file executable (chmod +x export.sh) 

# How to use: 
# ./export.sh apps
# ./export.sh projects

apps_file="apps.yaml"
projects_file="projects.yaml"
namespace="argocd"

apps() {
    # Clear existing content in the apps file
    > "$apps_file"

    apps=$(kubectl get apps -n $namespace --no-headers -o custom-columns=":metadata.name")

    for app in $apps; do
        kubectl get apps $app -n $namespace -o yaml | kubectl neat >> "$apps_file"
        echo "---" >> "$apps_file"
    done
}

projects() {
    # Clear existing content in the projects file
    > "$projects_file"

    projects=$(kubectl get appprojects -n $namespace --no-headers -o custom-columns=":metadata.name")

    for project in $projects; do
        kubectl get appprojects $project -n $namespace -o yaml | kubectl neat >> "$projects_file"
        echo "---" >> "$projects_file"
    done
}

# Check the command-line arguments
if [ $# -eq 0 ]; then
    echo "No arguments provided. Usage: ./export.sh <name>"
    exit 1
fi

function_name=$1

case $function_name in
        apps)
        apps
        ;;
        projects)
        projects
        ;;
    *)
        echo "Invalid function name. Available functions: apps, projects"
        exit 1
        ;;
esac
