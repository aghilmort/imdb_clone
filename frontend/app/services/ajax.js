import AjaxService from 'ember-ajax/services/ajax';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';

export default AjaxService.extend({
	namespace: '/api/v1',
	host: 'http://localhost:3000',
  session: service(),
  headers: computed('session.authToken', {
    get() {
      let headers = {};
      const authToken = this.get('session.data.authenticated.token');
      if (authToken) {
        headers['Authorization'] = `Token ${authToken}`;
      }
      return headers;
    }
  })
});