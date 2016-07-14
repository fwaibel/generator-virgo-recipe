dockerizor {
	repository = 'virgo-recipe/<%= guideShortName %>-app'
	description = 'Virgo Recipe <%= recipeName %> created with Gradle Plugin: com.eclipsesource.dockerizor'

	virgoHome = '/home/virgo/virgo-recipe-<%= guideShortName %>'

	pickupFiles = ['recipe-<%= guideShortName %>.plan']
}

repositories {
	mavenCentral()
}

dependencies {
	repositoryUsr project(':org.eclipse.virgo.samples.recipe.<%= guideShortName %>')
}
