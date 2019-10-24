import Route from '@ember/routing/route';
import RouteMixin from 'ember-cli-pagination/remote/route-mixin';

export default Route.extend(RouteMixin, {
	queryParams: {
		page: {
			refreshModel: true
		}
	},
	perPage: 9,
	model() {
		return this.findPaged('movie', {});
	}
});