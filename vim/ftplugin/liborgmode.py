# -*- coding: utf-8 -*-

import re
from UserList import UserList

DIRECTION_FORWARD  = True
DIRECTION_BACKWARD = False

def flatten_list(l):
	res = []
	if type(l) in (tuple, list) or isinstance(l, UserList):
		for i in l:
			if type(i) in (list, tuple) or isinstance(i, UserList):
				res.extend(flatten_list(i))
			else:
				res.append(i)
	return res

class MultiPurposeList(UserList):
	u""" A Multi Purpose List is a list that calls a user defined hook on
	change. The impelementation is very basic - the hook is called without any
	parameters. Otherwise the Multi Purpose List can be used like any other
	list.

	The member element "data" can be used to fill the list without causing the
	list to be marked dirty. This should only be used during initialization!
	"""

	def __init__(self, initlist=None, on_change=None):
		UserList.__init__(self, initlist)
		self._on_change = on_change

	def _changed(self):
		u"""
		Call hook
		"""
		if callable(self._on_change):
			self._on_change()

	def __setitem__(self, i, item):
		UserList.__setitem__(self, i, item)
		self._changed()

	def __delitem__(self, i):
		UserList.__delitem__(self, i)
		self._changed()

	def __setslice__(self, i, j, other):
		UserList.__setslice__(self, i, j, other)
		self._changed()

	def __delslice__(self, i, j):
		UserList.__delslice__(self, i, j)
		self._changed()

	def __iadd__(self, other):
		res = UserList.__iadd__(self, other)
		self._changed()
		return res

	def __imul__(self, n):
		res = UserList.__imul__(self, n)
		self._changed()
		return res

	def append(self, item):
		UserList.append(self, item)
		self._changed()

	def insert(self, i, item):
		UserList.insert(self, i, item)
		self._changed()

	def pop(self, i=-1):
		item = self[i]
		del self[i]
		return item

	def remove(self, item):
		self.__delitem__(self.data.index(item))

	def reverse(self):
		UserList.reverse(self)
		self._changed()

	def sort(self, *args, **kwds):
		UserList.sort(self, *args, **kwds)
		self._changed()

	def extend(self, other):
		UserList.extend(self, other)
		self._changed()

class HeadingList(MultiPurposeList):
	u"""
	A Heading List just contains headings. It's used for documents to store top
	level headings and for headings to store subheadings.

	A Heading List must be linked to a Document or Heading!

	See documenatation of MultiPurposeList for more information.
	"""
	def __init__(self, initlist=None, obj=None):
		"""
		:initlist:	Initial data
		:obj:		Link to a concrete Heading or Document object
		"""
		# it's not necessary to register a on_change hook because the heading
		# list will itself take care of marking headings dirty or adding
		# headings to the deleted headings list
		MultiPurposeList.__init__(self)

		self._obj = obj

		# initialization must be done here, because
		# self._document is not initialized when the
		# constructor of MultiPurposeList is called
		if initlist:
			self.extend(initlist)

	@classmethod
	def is_heading(cls, obj):
		return isinstance(obj, Heading)

	def _get_document(self):
		if self.__class__.is_heading(self._obj):
			return self._obj._document
		return self._obj

	def _add_to_deleted_headings(self, item):
		u"""
		Serialize headings so that all subheadings are also marked for deletion
		"""
		if not self._get_document():
			# HeadingList has not been associated yet
			return

		if type(item) in (list, tuple) or isinstance(item, UserList):
			for i in flatten_list(item):
				self._add_to_deleted_headings(i)
		else:
			self._get_document()._deleted_headings.append(item)
			self._add_to_deleted_headings(item.children)

	def _associate_heading(self, item, children=False):
		"""
		:item:		The heading or list to associate with the current heading
		:children:	Marks whether children are processed in the current
					iteration or not (should not be use, it's set automatically)
		"""
		# TODO this method should be externalized and moved to the Heading class
		if type(item) in (list, tuple) or isinstance(item, UserList):
			for i in flatten_list(item):
				self._associate_heading(i, children=children)
		else:
			item.set_dirty()
			item._orig_start = None
			item._orig_len = None
			d = self._get_document()
			if item._document != d:
				item._document = d
			if not children:
				if d == self._obj:
					# self._obj is a Document
					item._parent = None
				elif item._parent != self._obj:
					# self._obj is a Heading
					item._parent = self._obj

			self._associate_heading(item.children, children=True)

	def __setitem__(self, i, item):
		if not self.__class__.is_heading(item):
			raise ValueError(u'Item is not a heading!')
		if item in self.data:
			raise ValueError(u'Heading is already part of this list!')
		self._add_to_deleted_headings(self[i])

		self._associate_heading(item)
		MultiPurposeList.__setitem__(self, i, item)

	def __setslice__(self, i, j, other):
		o = other
		if self.__class__.is_heading(o):
			o = (o, )
		o = flatten_list(o)
		for item in o:
			if not self.__class__.is_heading(item):
				raise ValueError(u'List contains items that are not a heading!')
		i = max(i, 0); j = max(j, 0)
		self._add_to_deleted_headings(self.data[i:j])
		self._associate_heading(o)
		MultiPurposeList.__setslice__(self, i, j, o)

	def __delitem__(self, i):
		self._add_to_deleted_headings(self.data[i])
		MultiPurposeList.__delitem__(self, i)

	def __delslice__(self, i, j):
		i = max(i, 0); j = max(j, 0)
		self._add_to_deleted_headings(self.data[i:j])
		MultiPurposeList.__delslice__(self, i, j)

	def __iadd__(self, other):
		o = other
		if self.__class__.is_heading(o):
			o = (o, )
		for item in flatten_list(o):
			if not self.__class__.is_heading(item):
				raise ValueError(u'List contains items that are not a heading!')
		self._associate_heading(o)
		return MultiPurposeList.__iadd__(self, o)

	def __imul__(self, n):
		# TODO das müsste eigentlich ein klonen von objekten zur Folge haben
		return MultiPurposeList.__imul__(self, n)

	def append(self, item):
		if not self.__class__.is_heading(item):
			raise ValueError(u'Item is not a heading!')
		if item in self.data:
			raise ValueError(u'Heading is already part of this list!')
		self._associate_heading(item)
		MultiPurposeList.append(self, item)

	def insert(self, i, item):
		self._associate_heading(item)
		MultiPurposeList.insert(self, i, item)

	def pop(self, i=-1):
		item = self[i]
		self._add_to_deleted_headings(item)
		del self[i]
		return item

	def remove(self, item):
		MultiPurposeList.remove(self, item)

	def reverse(self):
		for i in self:
			i.set_dirty()
		MultiPurposeList.reverse(self)

	def sort(self, *args, **kwds):
		for i in self:
			i.set_dirty()
		MultiPurposeList.sort(*args, **kwds)

	def extend(self, other):
		o = other
		if self.__class__.is_heading(o):
			o = (o, )
		for item in o:
			if not self.__class__.is_heading(item):
				raise ValueError(u'List contains items that are not a heading!')
		self._associate_heading(o)
		MultiPurposeList.extend(self, o)

REGEX_HEADING = re.compile(u'^(?P<level>\*+)(?P<todotitle>(\s+(?P<todo>[^\s]+))?(\s+(?P<title>.*?))?)\s*(\s(?P<tags>:[\w_:]+:))?$', flags=re.U|re.L)
REGEX_TODO = re.compile(u'^[^\s]*$')

class Heading(object):
	u""" Structural heading object """

	def __init__(self, level=1, title=u'', tags=None, todo=None, body=None):
		u"""
		:level:		Level of the heading
		:title:		Title of the heading
		:tags:		Tags of the heading
		:todo:		Todo state of the heading
		:body:		Body of the heading
		"""
		object.__init__(self)

		self._document      = None
		self._parent        = None
		self._children      = HeadingList(obj=self)
		self._orig_start    = None
		self._orig_len      = 0

		self._dirty_heading = False
		self._level         = level
		self._todo          = None
		if todo: self.todo  = todo
		self._tags          = MultiPurposeList(on_change=self.set_dirty_heading)
		self._title         = u''
		if title: self.title = title
		if tags: self.tags   = tags

		self._dirty_body    = False
		self._body          = MultiPurposeList(on_change=self.set_dirty_body)
		if body: self.body  = body

	def __unicode__(self):
		res = u'*' * self.level
		if self.todo:
			res += u' ' + self.todo
		res += u' ' + self.title

		# compute position of tags
		if self.tags:
			tabs = 0
			spaces = 2
			tags = (u':%s:' % (u':'.join(self.tags)))

			ts = 8
			tag_column = 77
			if self.document:
				ts = self.document.tabstop
				tag_column = self.document.tag_column

			len_heading = len(res)
			len_tags = len(tags)
			if len_heading + spaces + len_tags < tag_column:
				spaces_to_next_tabstop =  ts - divmod(len_heading, ts)[1]

				if len_heading + spaces_to_next_tabstop + len_tags < tag_column:
					tabs, spaces = divmod(tag_column - (len_heading + spaces_to_next_tabstop + len_tags), ts)

					if spaces_to_next_tabstop:
						tabs += 1
				else:
					spaces = tag_column - (len_heading + len_tags)

			res += u'\t' * tabs + u' ' * spaces + tags
		return res

	def __str__(self):
		return self.__unicode__().encode(u'utf-8')

	def __len__(self):
		# 1 is for the heading's title
		return 1 + len(self.body)

	@classmethod
	def parse_heading_from_data(cls, data, document=None, orig_start=None):
		u""" Construct a new heading from the provided data

		:document:		The document object this heading belongs to
		:data:			List of lines
		:orig_start:	The original start of the heading in case it was read
						from a document. If orig_start is provided, the
						resulting heading will not be marked dirty.

		:returns:	The newly created heading
	    """
		def parse_title(heading_line):
			m = REGEX_HEADING.match(heading_line)
			if m:
				r = m.groupdict()
				tags = filter(lambda x: x != u'', r[u'tags'].split(u':')) if r[u'tags'] else []
				todo = r[u'todo']
				if not todo or todo == todo.upper():
					title = r[u'title'] if r[u'title'] else u''
				else:
					todo = None
					title = r[u'todotitle'].strip()
				return (len(r[u'level']), todo, title, tags)
			raise ValueError(u'Data doesn\'t start with a heading definition.')

		if not data:
			raise ValueError(u'Unable to create heading, no data provided.')

		h = cls()
		h.level, h.todo, h.title, h.tags = parse_title(data[0])
		h.body = data[1:]
		if orig_start is not None:
			h._dirty_heading = False
			h._dirty_body    = False
			h._orig_start    = orig_start
			h._orig_len      = len(h)
		if document:
			h._document = document

		return h

	@classmethod
	def identify_heading(cls, line):
		u""" Test if a certain line is a heading or not.

		:line: the line to check

		:returns: level
		"""
		level = 0
		if not line:
			return None
		for i in xrange(0, len(line)):
			if line[i] == u'*':
				level += 1
				if len(line) > (i + 1) and line[i+1] in (u'\t', u' '):
					return level
			else:
				return None

	@property
	def is_dirty(self):
		u""" Return True if the heading's body is marked dirty """
		return self._dirty_heading or self._dirty_body

	@property
	def is_dirty_heading(self):
		u""" Return True if the heading is marked dirty """
		return self._dirty_heading

	@property
	def is_dirty_body(self):
		u""" Return True if the heading's body is marked dirty """
		return self._dirty_body

	def get_index_in_parent_list(self):
		""" Retrieve the index value of current heading in the parents list of
		headings. This works also for top level headings.

		:returns:	Index value or None if heading doesn't have a
					parent/document or is not in the list of headings
	    """
		if self.parent:
			if self in self.parent.children:
				return self.parent.children.index(self)
		elif self.document:
			if self in self.document.headings:
				return self.document.headings.index(self)

	def get_parent_list(self):
		""" Retrieve the parents list of headings. This works also for top
		level headings.

		:returns:	List of headings or None if heading doesn't have a
					parent/document or is not in the list of headings
	    """
		if self.parent:
			if self in self.parent.children:
				return self.parent.children
		elif self.document:
			if self in self.document.headings:
				return self.document.headings

	def set_dirty(self):
		u""" Mark the heading and body dirty so that it will be rewritten when
		saving the document """
		self._dirty_heading = True
		self._dirty_body = True

	def set_dirty_heading(self):
		u""" Mark the heading dirty so that it will be rewritten when saving the
		document """
		self._dirty_heading = True

	def set_dirty_body(self):
		u""" Mark the heading's body dirty so that it will be rewritten when
		saving the document """
		self._dirty_body = True

	@property
	def document(self):
		u""" Read only access to the document. If you want to change the
		document, just assign the heading to another document """
		return self._document

	@property
	def parent(self):
		u""" Access to the parent heading """
		return self._parent

	@property
	def number_of_parents(self):
		u""" Access to the number of parent headings before reaching the root
		document """
		def count_parents(h):
			if h.parent:
				return 1 + count_parents(h.parent)
			else:
				return 0
		return count_parents(self)

	@property
	def previous_sibling(self):
		u""" Access to the previous heading that's a sibling of the current one
		"""
		if self.parent and self in self.parent.children:
			idx = self.parent.children.index(self)
			if idx > 0:
				return self.parent.children[idx - 1]
		elif not self.parent and self.document and self in self.document.headings:
			idx = self.document.headings.index(self)
			if idx > 0:
				return self.document.headings[idx - 1]

	@property
	def next_sibling(self):
		u""" Access to the next heading that's a sibling of the current one """
		if self.parent and self in self.parent.children:
			idx = self.parent.children.index(self)
			if len(self.parent.children) > idx + 1:
				return self.parent.children[idx + 1]
		elif not self.parent and self.document and self in self.document.headings:
			idx = self.document.headings.index(self)
			if len(self.document.headings) > idx + 1:
				return self.document.headings[idx + 1]

	@property
	def previous_heading(self):
		u""" Serialized access to the previous heading """
		if self.previous_sibling:
			h = self.previous_sibling
			while h.children:
				h = h.children[-1]
			return h
		elif self.parent:
			return self.parent

	@property
	def next_heading(self):
		u""" Serialized access to the next heading """
		if self.children:
			return self.children[0]
		elif self.next_sibling:
			return self.next_sibling
		else:
			h = self.parent
			while h:
				if h.next_sibling:
					return h.next_sibling
				else:
					h = h.parent

	@property
	def start(self):
		u""" Access to the starting line of the heading """
		if not self.document:
			return

		def compute_start(h):
			if h:
				return len(h) + compute_start(h.previous_heading)
			return len(self.document.meta_information) if self.document.meta_information else 0
		return compute_start(self.previous_heading)

	@property
	def start_vim(self):
		if self.start is not None:
			return self.start + 1

	@property
	def end(self):
		u""" Access to the ending line of the heading """
		if self.start is not None:
			return self.start + len(self.body)

	@property
	def end_vim(self):
		if self.end is not None:
			return self.end + 1

	@property
	def end_of_last_child(self):
		u""" Access to end of the last child """
		if self.children:
			child = self.children[-1]
			while child.children:
				child = child.children[-1]
			return child.end
		return self.end

	@property
	def end_of_last_child_vim(self):
		return self.end_of_last_child + 1

	def children():
		u""" Subheadings of the current heading """
		def fget(self):
			return self._children
		def fset(self, value):
			v = value
			if type(v) in (list, tuple) or isinstance(v, UserList):
				v = flatten_list(v)
			self._children[:] = v
		def fdel(self):
			del self.children[:]
		return locals()
	children = property(**children())

	@property
	def first_child(self):
		u""" Access to the first child heading or None if no children exist """
		if self.children:
			return self.children[0]

	@property
	def last_child(self):
		u""" Access to the last child heading or None if no children exist """
		if self.children:
			return self.children[-1]

	def level():
		u""" Access to the heading level """
		def fget(self):
			return self._level
		def fset(self, value):
			self._level = int(value)
			self.set_dirty_heading()
		def fdel(self):
			self.level = None
		return locals()
	level = property(**level())

	def todo():
		u""" Todo state of current heading. When todo state is set, it will be
		converted to uppercase """
		def fget(self):
			# extract todo state from heading
			return self._todo
		def fset(self, value):
			# update todo state
			if type(value) not in (unicode, str, type(None)):
				raise ValueError(u'Todo state must be a string or None.')
			if value and not REGEX_TODO.match(value):
				raise ValueError(u'Found non allowed character in todo state!')
			if not value:
				self._todo = None
			else:
				v = value
				if type(v) == str:
					v = v.decode(u'utf-8')
				self._todo = v.upper()
			self.set_dirty_heading()
		def fdel(self):
			self.todo = None
		return locals()
	todo = property(**todo())

	def title():
		u""" Title of current heading """
		def fget(self):
			return self._title.strip()
		def fset(self, value):
			if type(value) not in (unicode, str):
				raise ValueError(u'Title must be a string.')
			v = value
			if type(v) == str:
				v = v.decode(u'utf-8')
			self._title = v.strip()
			self.set_dirty_heading()
		def fdel(self):
			self.title = u''
		return locals()
	title = property(**title())

	def tags():
		u""" Tags of the current heading """
		def fget(self):
			return self._tags
		def fset(self, value):
			v = value
			if type(v) not in (list, tuple) or isinstance(v, UserList):
				v = list(unicode(v))
			if type(v) in (unicode, str):
				v = list(v)
			v = flatten_list(v)
			v_decoded = []
			for i in v:
				if type(i) not in (unicode, str):
					raise ValueError(u'Found non string value in tags!')
				if u' ' in i \
						or u'\t' in i \
						or u':' in i:
					raise ValueError(u'Found non allowed character in tag!')
				i_tmp = i.strip().replace(' ', '_').replace('\t', '_')
				if type(i) == str:
					i_tmp = i.decode(u'utf-8')
				v_decoded.append(i_tmp)

			self._tags[:] = v_decoded
		def fdel(self):
			self.tags = []
		return locals()
	tags = property(**tags())

	def body():
		u""" Holds the content belonging to the heading """
		def fget(self):
			return self._body

		def fset(self, value):
			if type(value) in (list, tuple) or isinstance(value, UserList):
				self._body[:] = flatten_list(value)
			elif type(value) in (str, ):
				self._body[:] = value.decode('utf-8').split(u'\n')
			elif type(value) in (unicode, ):
				self._body[:] = value.split(u'\n')
			else:
				self.body = list(unicode(value))
		def fdel(self):
			self.body = []
		return locals()
	body = property(**body())

class Document(object):
	u""" Representation of a whole org-mode document """

	def __init__(self):
		u"""
		Don't call this constructor directly but use one of the concrete
		implementations.
		"""
		object.__init__(self)

		# is a list - only the Document methods should work with this list!
		self._content                   = None
		self._dirty_meta_information    = False
		self._meta_information          = MultiPurposeList(on_change = self.set_dirty_meta_information)
		self._orig_meta_information_len = None
		self._headings                  = HeadingList(obj=self)
		self._deleted_headings          = []

		# settings needed to align tags properly
		self._tabstop                    = 8
		self._tag_column                 = 77

	def __unicode__(self):
		if self.meta_information is None:
			return '\n'.join(self.all_headings())
		return '\n'.join(self.meta_information) + '\n' + '\n'.join(['\n'.join([unicode(i)] + i.body) for i in self.all_headings()])

	def __str__(self):
		return self.__unicode__().encode(u'utf-8')

	def tabstop():
		""" Tabstop for this document """
		def fget(self):
			return self._tabstop
		def fset(self, value):
			self._tabstop = value
		return locals()
	tabstop = property(**tabstop())

	def tag_column():
		""" The column all tags are right-aligned to """
		def fget(self):
			return self._tag_column
		def fset(self, value):
			self._tag_column = value
		return locals()
	tag_column = property(**tag_column())

	def load(self, heading=Heading):
		u""" Initialize all headings in document - build DOM. This method
		should be call prior to accessing the document.

		:returns:	self
	    """
		def init_heading(heading):
			u"""
			:returns	the initialized heading
			"""
			start = heading.end + 1
			while True:
				new_heading = self.find_heading(start, heading=heading)

				# * Heading 1 <- heading
				# * Heading 1 <- sibling
				# or
				# * Heading 2 <- heading
				# * Heading 1 <- parent's sibling
				if not new_heading or \
						new_heading.level <= heading.level:
					break

				# * Heading 1 <- heading
				#  * Heading 2 <- first child
				#  * Heading 2 <- another child
				new_heading._parent = heading
				heading.children.data.append(new_heading)
				# the start and end computation is only
				# possible when the new heading was properly
				# added to the document structure
				init_heading(new_heading)
				if new_heading.children:
					# skip children
					start = new_heading.end_of_last_child + 1
				else:
					start = new_heading.end + 1

			return heading

		h = self.find_heading(heading=heading)
		# initialize meta information
		if h:
			self._meta_information.data.extend(self._content[:h._orig_start])
		else:
			self._meta_information.data.extend(self._content[:])
		self._orig_meta_information_len = len(self.meta_information)

		# initialize dom tree
		while h:
			self.headings.data.append(h)
			init_heading(h)
			h = self.find_heading(h.end_of_last_child + 1, heading=heading)

		return self

	def meta_information():
		u"""
		Meta information is text that precedes all headings in an org-mode
		document. It might contain additional information about the document,
		e.g. author
		 """
		def fget(self):
			return self._meta_information

		def fset(self, value):
			if self._orig_meta_information_len is None:
				self._orig_meta_information_len = len(self.meta_information)
			if type(value) in (list, tuple) or isinstance(value, UserList):
				self._meta_information[:] = flatten_list(value)
			elif type(value) in (str, ):
				self._meta_information[:] = value.decode(u'utf-8').split(u'\n')
			elif type(value) in (unicode, ):
				self._meta_information[:] = value.split(u'\n')
			self.set_dirty_meta_information()
		def fdel(self):
			self.meta_information = u''
		return locals()
	meta_information = property(**meta_information())

	def headings():
		u""" List of top level headings """
		def fget(self):
			return self._headings
		def fset(self, value):
			self._headings[:] = value
		def fdel(self):
			del self.headings[:]
		return locals()
	headings = property(**headings())

	def write(self):
		u""" write the document

		:returns:	True if something was written, otherwise False
		"""
		raise NotImplementedError(u'Abstract method, please use concrete impelementation!')

	def set_dirty_meta_information(self):
		u""" Mark the meta information dirty so that it will be rewritten when
		saving the document """
		self._dirty_meta_information = True

	@property
	def is_dirty(self):
		u"""
		Return information about unsaved changes for the document and all
		related headings.

		:returns:	 Return True if document contains unsaved changes.
		"""
		if self.is_dirty_meta_information:
			return True

		if self._deleted_headings:
			return True

		if not self.headings:
			return False

		for h in self.all_headings():
			if h.is_dirty:
				return True

		return False

	@property
	def is_dirty_meta_information(self):
		u""" Return True if the meta information is marked dirty """
		return self._dirty_meta_information

	def all_headings(self):
		u""" Iterate over all headings of the current document in serialized
		order

		:returns:	Returns an iterator object which returns all headings of
					the current file in serialized order
		"""
		if not self.headings:
			raise StopIteration()

		h = self.headings[0]
		while h:
			yield h
			h = h.next_heading
		raise StopIteration()

	def find_heading(self, position=0, direction=DIRECTION_FORWARD, heading=Heading):
		u""" Find heading in the given direction

		:postition:	starting line, counting from 0 (in vim you start counting from 1, don't forget)
		:direction:	downwards == DIRECTION_FORWARD, upwards == DIRECTION_BACKWARD
		:heading:	Heading class from which new heading objects will be instanciated

		:returns:	New heading object or None
		"""
		len_cb = len(self._content)

		if position < 0 or position > len_cb:
			return

		tmp_line = position
		start = None
		end = None

		# Search heading upwards
		if direction == DIRECTION_FORWARD:
			while tmp_line < len_cb:
				if heading.identify_heading(self._content[tmp_line]) is not None:
					if start is None:
						start = tmp_line
					elif end is None:
						end = tmp_line - 1
					if start is not None and end is not None:
						break
				tmp_line += 1
		else:
			while tmp_line >= 0 and tmp_line < len_cb:
				print tmp_line
				if heading.identify_heading(self._content[tmp_line]) is not None:
					if start is None:
						start = tmp_line
					elif end is None:
						end = tmp_line - 1
					if start is not None and end is not None:
						break
				tmp_line -= 1 if start is None else -1

		if start is not None and end is None:
			end = len_cb - 1
		if start is not None and end is not None:
			return heading.parse_heading_from_data(self._content[start:end + 1], document=self, orig_start=start)
