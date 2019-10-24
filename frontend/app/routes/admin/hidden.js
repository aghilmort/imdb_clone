import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';
import RouteMixin from 'ember-cli-pagination/remote/route-mixin';
import Route from '@ember/routing/route';

export default Route.extend(AuthenticatedRouteMixin, RouteMixin, {
	queryParams: {
		page: {
			refreshModel: true
		}
	},
	perPage: 9,
	model() {
		return this.findPaged('movie', { hidden: true });
	}
});