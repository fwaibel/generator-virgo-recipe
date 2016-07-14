dockerizor {
	repository = 'virgo-recipe/<%= guideShortName %>-runtime'
	description = 'Virgo Recipe <%= recipeName %> (runtime-only) created with Gradle Plugin: com.eclipsesource.dockerizor'

	virgoHome = '/home/virgo/virgo-recipe-<%= guideShortName %>-runtime'
}

repositories {
	mavenCentral()
}

dependencies {
}
