{{flutter_js}}
{{flutter_build_config}}

// Manipulate the DOM to add a loading spinner will be rendered with this HTML:
// <div class="loading">
//   <div class="loader" />
// </div>


let useHtml = false;
let loading = document.querySelector('#progressBarText');
let loadingContainer = document.querySelector('#loadingContainer');
loading.textContent = "Starte. Bitte einen moment Geduld...";

// Customize the app initialization process
_flutter.loader.load({
    onEntrypointLoaded: async function(engineInitializer) {
        loading.textContent = "Lade BladeNight-Web-App...";
        const appRunner = await engineInitializer.initializeEngine();

        // Remove the loading spinner when the app runner is ready
        if (document.body.contains(loadingContainer)) {
            loadingContainer.remove();
        }

        await appRunner.runApp();
    }
});