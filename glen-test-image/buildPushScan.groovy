#!groovy

@Library('Utils')
import com.redhat.*

node {
    stage('checkout') {
        checkout scm
    }

    dockerBuildPush {
        credentialsId = "ContainerZone"
        contextDir = "glen-test-image"
        imageName = "glen-test-image"
        imageTag = "1.0"
    }

    containerZoneScan {
        credentialsId = "ContainerZone"
        openShiftUri = "insecure://api.rhc4tp.openshift.com"
        imageName = "glen-test-image"
        imageTag = "1.0"
    }
}
