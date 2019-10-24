import Controller from '@ember/controller';
import { inject as service } from '@ember/service';

export default Controller.extend({
  session: service('session'),
  ajax: service('ajax'),
  actions: {
    async logout() {
      let session = this.get('session');

      await this.get('ajax').request('../../users/sign_out', { method: 'DELETE' })
        .then(function () {
          session.invalidate();
        });
    },
    login() {
      this.transitionToRoute('login');
    }
  }
});