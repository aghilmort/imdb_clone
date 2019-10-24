import Component from '@ember/component';
import { alias } from '@ember/object/computed';
import { getOwner } from '@ember/application';
import { inject as service } from '@ember/service';

export default Component.extend({
	model: alias("content"),
	session: service('session'),
	actions: {
		new() {
			getOwner(this).lookup('router:main').transitionTo('movies.new');
		},
		editMovie(id) {
			getOwner(this).lookup('router:main').transitionTo(`/movies/${id}/edit`);
		},
		showMovie(id) {
			getOwner(this).lookup('router:main').transitionTo(`/movies/${id}`);
		}
	}
});
