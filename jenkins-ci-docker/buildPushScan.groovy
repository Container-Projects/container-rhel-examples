#!groovy

@Library('Utils')
import com.redhat.*

node {
    stage('checkout') {
        checkout scm
    }

    dockerBuildPush {
        credentialsId = "ContainerZone"
        contextDir = "jenkins-ci-docker"
        imageName = "jenkins-ci-docker"
        imageTag = "1.0"
    }

    containerZoneScan {
        credentialsId = "ContainerZone"
        openShiftUri = "insecure://api.rhc4tp.openshift.com"
        imageName = "jenkins-ci-docker"
        imageTag = "1.0"
    }
}
