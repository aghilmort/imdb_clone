// Devise
import DS from 'ember-data';
import { inject as service } from '@ember/service';
import DataAdapterMixin from "ember-simple-auth/mixins/data-adapter-mixin";
// import AjaxServiceSupport from 'ember-ajax/mixins/ajax-support';

const { JSONAPIAdapter } = DS;

export default JSONAPIAdapter.extend(DataAdapterMixin, {
// export default JSONAPIAdapter.extend(AjaxServiceSupport, {
	namespace: 'api/v1',
	host: 'http://localhost:3000',
  session: service(),
  // defaults
  // identificationAttributeName: 'email'
  // tokenAttributeName: 'token'
  authorize(xhr) {
    let { email, token } = this.get('session.data.authenticated');
    let authData = `Token token="${token}", email="${email}"`;
    xhr.setRequestHeader('Authorization', authData);
  }
});