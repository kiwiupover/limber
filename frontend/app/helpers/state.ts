import { tracked } from '@glimmer/tracking';

class State {
  @tracked value: unknown;

  update = (nextValue: unknown) => (this.value = nextValue);
  toggle = () => (this.value = !this.value);
}

export default function state() {
  return new State();
}
