import { createRoot } from "react-dom-client";
import h from "components/htm_create_element";
import * as Components from "components";

document.addEventListener("DOMContentLoaded", () => {
  const mountPoints = document.querySelectorAll("[data-react-component]");

  mountPoints.forEach((mountPoint) => {
    try {
      const { reactComponent, props: propsData } = mountPoint.dataset;

      const Component = Components[reactComponent];
      if (!Component) {
        console.warn(`WARNING: No component found for: ${reactComponent}`);
        return;
      }

      const props = propsData ? JSON.parse(propsData) : {};

      const root = createRoot(mountPoint);
      root.render(h`<${Component} ...${props} />`);
    } catch (error) {
      console.error("Error mounting React component:", error);
    }
  });
});
