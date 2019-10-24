import PageNumbers from 'ember-cli-pagination/components/page-numbers';
import { alias } from '@ember/object/computed';

export default PageNumbers.extend({
	page: alias("content.page"),
  perPage: alias("content.perPage"),
  totalPages: alias("content.meta.total_pages")
});
