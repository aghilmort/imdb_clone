import EmberRouter from '@ember/routing/router';
import config from './config/environment';

const Router = EmberRouter.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('movies', function() {
    this.route('new');
    this.route('index', { path: '/' });
    this.route('show', { path: ':movie_id' });
    this.route('edit', { path: ':movie_id/edit' });
    this.route('delete', { path: ':movie_id/delete' });
  });

  this.route('login', { path: '/users/sign_in' });

  this.route('ratings');

  this.route('admin', function() {
    this.route('hidden');
  });
  this.route('categories', function() {
    this.route('show');
  });

  this.route('genres', function() {
    this.route('index', { path: ':slug' });
    this.route('show', { path: ':slug/:sub_category_slug' });
  });

  this.route('index', { path: '/' });
});

export default Router;
