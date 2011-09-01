WP = {
	
	initHomePage: function() {
		console.log('initHomePage');
		//WP.subscribeToAuthResponseChangeEvent();
		//WP.subscribeToStatusChangeEvent();
		
		FB.getLoginStatus(function(response) {
			console.log('getLoginStatus');
	  	if (response.authResponse) {
				console.log('logged in');
				$('#my-activities').show();
	  	}
			else {
				console.log('not logged in');
				$('#fb-login').show();
				WP.subscribeToLoginEvent();
	  	}
		});
	},
	
	subscribeToAuthResponseChangeEvent: function() {
		console.log('one');
		FB.Event.subscribe('auth.authResponseChange', function( response ) {
			console.log(response);
		});
	},
	
	subscribeToStatusChangeEvent: function() {
		console.log('two');
		FB.Event.subscribe('auth.statusChange', function( response ) {
			console.log(response);
		});
	},
	
	subscribeToLoginEvent: function() {
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
						alert('logged out!');
					});
					alert('Uh oh! Looks like something broke.');
				}
			});
		});
	}
}