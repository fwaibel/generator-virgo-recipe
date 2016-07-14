buildscript {
	repositories {
		mavenCentral()
        jcenter()
	    maven {
	      url "https://plugins.gradle.org/m2/"
	    }
	}
	dependencies {
		classpath "gradle.plugin.org.eclipse.virgo.bundlor:bundlor-plugin:0.2"
		classpath "gradle.plugin.com.eclipsesource.dockerizor:dockerizor:0.8.0"
		classpath 'org.asciidoctor:asciidoctor-gradle-plugin:1.5.3'
	}
}

apply plugin: 'org.asciidoctor.convert'

ext.virgoProjects = [
	project(':org.eclipse.virgo.samples.recipe.<%= guideShortName %>'),
]

ext.dockerProjects = subprojects.findAll {it.name.contains('-runtime') || it.name.contains('-app')}

configure(virgoProjects + dockerProjects) {
	repositories {
		mavenLocal()
		mavenCentral()
		ivy {
			url "http://build.eclipse.org/rt/virgo/ivy/bundles/release/"
			layout "pattern", { artifact "[organisation]/[module]/[revision]/[artifact]-[revision].[ext]" }
		}
	}
}

configure(virgoProjects) {
	apply plugin: 'java'
	apply plugin: 'eclipse'
	apply plugin: 'eclipse-wtp'

	version = '0.1.0.BUILD-SNAPSHOT'

	compileJava {
		options.encoding = 'utf-8'
		options.fork = true
		doFirst {
			options.forkOptions.with {
				executable = 'java'
				jvmArgs = [
					'-cp',
					configurations.ecj.asPath,
					'org.eclipse.jdt.internal.compiler.batch.Main',
					'-source',
					'1.8',
	                '-target',
	                '1.8',
					'-warn:-unused'
				]
			}
		}
	}

	compileTestJava {
		options.encoding = 'utf-8'
		options.fork = true
		doFirst {
			options.forkOptions.with {
				executable = 'java'
				jvmArgs = [
					'-cp',
					configurations.ecj.asPath,
					'org.eclipse.jdt.internal.compiler.batch.Main',
					'-source',
					'1.8',
					'-target',
					'1.8',
					'-warn:-unused'
				]
			}
		}
	}

	eclipse {
		jdt {
			sourceCompatibility = 1.8
			targetCompatibility = 1.8
		}

		project {
		  	natures 'org.eclipse.virgo.ide.facet.core.bundlenature', 'org.eclipse.wst.common.project.facet.core.nature'
		}

		wtp {
		    facet {
				facets = []
				facet name: 'jst.java', version: '1.8'
				facet name: 'org.eclipse.virgo.server.bundle', version: '1.0'
			}
		}
	}

	configurations {  ecj { } }

	dependencies {
	    ecj group: "org.eclipse.jdt.core.compiler", name: "ecj", version: "4.4.2"
	}
}

configure(virgoProjects) {
	apply plugin: 'org.eclipse.virgo.bundlor'

	task('addProjectVersionToGradlePropertiesTask', type: Copy) {
		ext.outputDir = new File(buildDir, 'bundlor-properties')
		inputs.file project.rootProject.file('gradle.properties')
		outputs.dir ext.outputDir
		from project.rootProject.file('gradle.properties')
		into ext.outputDir
	}

	task('mergeClassesAndResources', type: Copy, dependsOn: 'compileJava') {
		ext.bundlorInputPath = new File(buildDir, 'bundlor-inputPath')
		inputs.file sourceSets.main.output.classesDir
		inputs.file sourceSets.main.resources
		outputs.dir ext.bundlorInputPath
		from sourceSets.main.output.classesDir
		from sourceSets.main.resources
		into ext.bundlorInputPath
	}

	project.tasks.'bundlor'.dependsOn('addProjectVersionToGradlePropertiesTask', 'mergeClassesAndResources')

	bundlor {
		ext.bundlorInputPath = new File(buildDir, 'bundlor-inputPath')
		project.tasks['bundlor'].inputs.file ext.bundlorInputPath
		manifestTemplatePath = "template.mf"
		propertiesPath = new File("${project.buildDir}/bundlor-properties/gradle.properties")
		inputPath = ext.bundlorInputPath
		failOnWarnings = false
	}
}

configure(dockerProjects) {
	// add the build task 'clean'
	apply plugin: 'base'

	// add the build task 'dockerize'
	apply plugin: 'com.eclipsesource.dockerizor'

	dockerizor {
		maintainer = 'Florian Waibel <fwaibel@eclipsesource.com>'

		createLocalCopy = System.properties['dockerizor.createLocalCopy'] ?: false
		removeAdminConsole = System.properties['dockerizor.removeAdminConsole'] ?: true
		removeSplash = System.properties['dockerizor.removeSplash'] ?: true

		virgoFlavour = 'VTS'
		virgoVersion = 'latest'
	}

	dockerize.dependsOn configurations.repositoryExt
	dockerize.dependsOn configurations.repositoryUsr
}

task wrapper(type: Wrapper) {
    gradleVersion = '2.10'
}
