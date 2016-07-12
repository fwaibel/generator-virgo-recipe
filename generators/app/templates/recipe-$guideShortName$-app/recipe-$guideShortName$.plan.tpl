<plan name="recipe-<%= guideShortName %>" version="0.1" scoped="false" atomic="true"
                xmlns="http://www.eclipse.org/virgo/schema/plan"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xsi:schemaLocation="
					http://www.eclipse.org/virgo/schema/plan
					http://www.eclipse.org/virgo/schema/plan/eclipse-virgo-plan.xsd">

        <artifact type="bundle" name="org.eclipse.virgo.samples.recipe.<%= recipePackage %>" version="[0.1, 1)" />
</plan>
