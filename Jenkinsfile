pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Unit tests') {
            steps {
                parallel(
                	"backend": {
                        echo 'testing..'
                    },
                    "ui": {
                        echo 'testing..'
                    }
                )
            }
        }
        stage('Deploy to live Server') {
        	when { expression { env.BRANCH_NAME == 'master' } }
            steps {
                echo 'Deploying....'
            }
        }
    }
}
