WP = {
	
	initHomePage: function() {
		console.log('initHomePage');
		FB.Event.subscribe('auth.login', function( response ) {
			console.log('auth.login');
			$.ajax({
			  type: 'POST',
			  url: '/login',
			  data: 'uid=' + response.session.uid + '&access_token=' + response.session.access_token,
				headers: {
					'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
				},
			  success: function( data, status, xhr ) {
					console.log('success');
					window.location = '/activities';
				},
				error: function( xhr, status, error ) {
					console.log('error');
					FB.logout(function(response) {
  					// user is now logged out
					});
					alert('Uh oh! Looks like something broke.');
				}
			});
		});
	}
}