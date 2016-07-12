dockerizor {
	repository = 'virgo-recipe/<%= guideShortName %>-app'
	description = 'Virgo Recipe <%= recipeName %> created with Gradle Plugin: com.eclipsesource.dockerizor'

	pickupFiles = ['recipe-<%= guideShortName %>.plan']
}

repositories {
	mavenCentral()
}

dependencies {
	repositoryUsr project(':org.eclipse.virgo.samples.recipe.<%= guideShortName %>')
}
