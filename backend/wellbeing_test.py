import app
import unittest
import os
import tempfile
import json

class BasicTestCase(unittest.TestCase):

	def test_index(self):
		"""
		initial test.ensure flask was set up correctly
		"""
		tester = app.app.test_client(self)
		response = tester.get('/', content_type = 'html/text')
		self.assertEqual(response.status_code, 200)

	def test_database(self):
		"""initial test. ensure that the database exists"""
		tester = os.path.exists("wellbeing")
		self.assertEqual(tester, True)

if __name__ == '__main__':
	unittest.main()