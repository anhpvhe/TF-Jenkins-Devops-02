pipeline {
    environment {
        GIT_URL = 'https://github.com/anhpvhe/TF-Jenkins-Devops-02.git'
        GIT_BRANCH = 'main'
        TERRAFORM_PATH = 'C:\\Terraform\\terraform.exe'
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    } 

    agent any
    stages {
        stage('checkout') {
            steps {
                dir('website-app') {
                    git branch: GIT_BRANCH, url: GIT_URL, credentialsId: 'git-credentials-id'
                }
            }
        }

        stage('Validate') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    bat "cd website-app && ${env.TERRAFORM_PATH} init"
                    bat "cd website-app && ${env.TERRAFORM_PATH} validate"
                    bat "cd website-app && ${env.TERRAFORM_PATH} plan"
                }
            }
        }

        stage('Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    def userInput = input(
                        id: 'confirm', message: 'Do you want to apply the plan?', parameters: [
                            [$class: 'BooleanParam', description: 'Apply the plan', name: 'apply']
                        ]
                    )
                    if (userInput) {
                        bat "cd website-app && ${env.TERRAFORM_PATH} apply"
                    } else {
                        echo "Apply aborted by user."
                    }
                }
            }
        }
    }
}