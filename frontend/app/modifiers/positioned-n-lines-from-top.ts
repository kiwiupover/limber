type PositionalArgs = [number, number];

export default function positionFromTop(element: HTMLElement, [lines, padding]: PositionalArgs) {
  let container = element.parentElement as Element;
  let lineHeight = getComputedStyle(container).lineHeight;

  element.setAttribute('style', `top: calc(${padding} + ${lineHeight} * ${lines - 1})`);
}
