import { tracked } from '@glimmer/tracking';
import { modifier } from 'ember-modifier';
import { Resource } from 'ember-resources/core';

import type { TemplateOnlyComponent as TOC } from '@ember/component/template-only';
import type { HelperLike } from "@glint/template";

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
export class ShadowHost extends Resource {
  /**
   * Glint defines too narrow of a type for in-element parameters
   * So we have to Lie to TS in a couple of places within here
   *  https://github.com/typed-ember/glint/issues/340
   */
  @tracked value: Element | undefined;

  update = (nextValue: ShadowRoot) => (this.value = nextValue as unknown as Element);
}

const attachShadow = modifier((element: Element, [setShadow]: [ShadowHost['update']]) => {
  setShadow(element.attachShadow({ mode: 'open' }));
}, { eager: false });

// index.html has the production-fingerprinted references to these links
// Ideally, we'd have some pre-processor scan everything for references to
// assets in public, but idk how to set that up
const getStyles = () => [...document.head.querySelectorAll('link')].map(link => link.href);

/**
 * Glint does not tie into any of the managers.
 *
 * See issue report:
 *   https://github.com/emberjs/rfcs/issues/822
 */
const state = ShadowHost as unknown as HelperLike<{ Args: {}; Return: ShadowHost }>;

const Shadowed: TOC<{
  Blocks: { default: [] }
}> =
<template>
  {{#let (state) as |shadow|}}
    <div data-shadow {{attachShadow shadow.update}}></div>

    {{#if shadow.value}}
      {{#in-element shadow.value}}
        {{#let (getStyles) as |styles|}}
          {{#each styles as |styleHref|}}
            <link rel="stylesheet" href={{styleHref}}>
          {{/each}}
        {{/let}}

        {{yield}}
      {{/in-element}}
    {{/if}}
  {{/let}}
</template>

export default Shadowed;
