import Component from '@ember/component';
import { computed } from '@ember/object';
import groupBy from 'ember-group-by';
import { inject as service } from '@ember/service';

export default Component.extend({
	store: service('store'),
  selectedElem: null,
	raw_categories: computed('model', function () {
		return this.store.findAll('category');
	}),
	categoriesBySlug: groupBy('raw_categories', 'slug'),
	didInsertElement() {
		this._super(...arguments);
		this.set('selfReference', this);
	},
	clear() {
		this.set('selectedElem', null);
	},
	actions: {
		grabValue(value) {
			this.set('selectedElem', value);
		}
	}
});
