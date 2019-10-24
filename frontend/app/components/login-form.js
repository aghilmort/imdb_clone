import Component from '@ember/component';
import Ember from 'ember';

const { service } = Ember.inject;

export default Component.extend({
  session: service('session'),
  router: service('router'),
  errorMessage: null,
  actions: {
    async authenticate() {
      let { identification, password } =      
        this.getProperties('identification', 'password');
      await this.get('session')
        .authenticate('authenticator:devise', identification, password)
        .catch((reason) => {
          this.set('errorMessage', reason.error || reason);
        });

      if (!this.get('errorMessage')) {
        this.get('router').transitionTo('movies');
      }
    }
 }
});
