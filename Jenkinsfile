pipeline {
    agent {
        label 'worker'
    }
    tools {
        maven "maven"
        // docker "docker"
    }
    stages {
        stage("clone") {
            steps {
checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/dhairyashild/springboot-java-poject-small-devopsshack-copy.git']])       
                    }
        }
        stage("build") {
            steps {
                dir ('/home/ubuntu/jenkins/workspace/eks-project-full-cicd/'){
                sh 'mvn clean install'
                }
                    
                }
        }
        
        stage("sonar") {
            steps {
             sh '''mvn clean verify sonar:sonar \
  -Dsonar.projectKey=eks-project-full-cicd \
  -Dsonar.host.url=http://43.205.198.59:9000 \
  -Dsonar.login=sqp_0d6301c1635e55663c4b9d06f6b9d9b912940c60'''
                
                }
                    
                }
                
//     //               stage("jfrog") {
//     //                   agent {
//     //                       label 'jfrog'
//     // }
//     //         steps {
//     //               sh 'mvn deploy'  }
//     //     } 


    //               stage('Building image') {
    //   steps{
    //     script {
    //         dir ('/home/ubuntu/jenkins/workspace/')
    //     sh 'docker build -t image1 .'
    //     }
    //   }
    // }
    
    stage('ecr-push'){
        steps{
          sh 'aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/d8y1d3c0'
          sh 'docker build -t spring-app /home/ubuntu/jenkins/workspace/eks-project-full-cicd/'
          sh 'docker tag spring-app:latest public.ecr.aws/d8y1d3c0/spring-app:latest'
          sh 'docker push public.ecr.aws/d8y1d3c0/spring-app:latest'
        }
    }       
        }
}


    
