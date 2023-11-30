export const resource = (file) => `resource:///com/github/Aylur/ags/${file}.js`;
export const require = async (file) => (await import(resource(file))).default;
export const service = async (file) => await require(`service/${file}`);

export const App = await require("app");
export const Utils = await import(resource("utils"));
export const Variable = await require("variable");
export const Widget = await require("widget");

// Services
export const Battery = await service("battery");
export const Bluetooth = await service("bluetooth");
export const Hyprland = await service("hyprland");
export const Mpris = await service("mpris");
export const Network = await service("network");