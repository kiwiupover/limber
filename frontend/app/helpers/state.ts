import { tracked } from '@glimmer/tracking';

import { Resource } from 'ember-resources/core';

import type { HelperLike } from '@glint/template';

/**
 * Every custom-manager using object needs to have two types.
 * - one for templates / glint
 * - one for JS/TS
 *
 *
 * Because Glint doesn't have an integration with the managers,
 * this complexity is pushed into user space.
 *
 * See issue report:
 *   https://github.com/emberjs/rfcs/issues/822#issuecomment-1140541910
 */
class State extends Resource {
  @tracked value: unknown;

  update = (nextValue: unknown) => (this.value = nextValue);
  toggle = () => (this.value = !this.value);
}

/**
 * Glint does not tie into any of the managers.
 * See issue report:
 *   https://github.com/emberjs/rfcs/issues/822
 */
export default State as unknown as HelperLike<{
  Return: State;
}>;
