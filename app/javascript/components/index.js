import { createRoot } from "react-dom-client";
import h from "components/htm_create_element";
import Weather from "components/Weather";

document.addEventListener("DOMContentLoaded", () => {
  const mountPoints = document.querySelectorAll("[data-react-component]");
  mountPoints.forEach((mountPoint) => {    
    const componentName = mountPoint.dataset.reactComponent;
    if (componentName) {
      const Component = eval(componentName);
      if (Component) {
        const props = JSON.parse(mountPoint.dataset.props);
        const root = createRoot(mountPoint);
        root.render(h`<${Component} ...${props} />`);
      } else {
        console.warn(
          "WARNING: No component found for: ",
          componentName
        );
      }
    }
  });
});
