from django.contrib.staticfiles.testing import StaticLiveServerTestCase
from django.core.servers.basehttp import WSGIServer, WSGIRequestHandler
from django.test.testcases import LiveServerThread


# @see https://stackoverflow.com/questions/45981634/how-to-make-django-liveservertestcase-log-requests
from ..models import Choice


class VerboseLiveServerThread(LiveServerThread):
    def _create_server(self):
        return WSGIServer((self.host, self.port), WSGIRequestHandler, allow_reuse_address=False)


class PollTest(StaticLiveServerTestCase):
    server_thread_class = VerboseLiveServerThread

    fixtures = [
        'polls/tests/poll.json',
    ]

    def test_flow(self):
        self.assertEqual(0, Choice.objects.get(pk=1).votes)

        from subprocess import call
        exit_code = call([
            './cypress/run.sh',
            f'http://{self.server_thread.host}:{self.server_thread.port}',
            'cypress/integration/flow.js'
        ])

        self.assertEqual(0, exit_code)

        self.assertEqual(1, Choice.objects.get(pk=1).votes)
