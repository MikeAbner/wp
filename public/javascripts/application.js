WP = {
	
	initHomePage: function() {
		console.log('initHomePage');
		
		FB.getLoginStatus(function(response) {
			console.log('getLoginStatus');
	  	if ( response.session ) {
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
	},
	
	initActivitiesPage: function() {
		$("#occurred_on").dateinput({
			change: function() {
				var isoDate = this.getValue( 'yyyy-mm-dd' );
				$("#activity_occurred_on").val( isoDate );
			}
		});
		
		$('#add-activity-btn').click(function() {
			$('#new-activity').slideDown();
			return false;
		});
		$('#save-activity-btn').click(function() {
			WP.saveNewActivity();
			return false;
		});
		$('#cancel-btn').click(function() {
			WP.cancelNewActivity();
			return false;
		});
	},
	
	saveNewActivity: function() {
		$.ajax({
			type: 'POST',
			url: '/activities',
			data: $('#activity-form').serialize(),
			success: function( data, status, xhr ) {
				$('#new-activity').slideUp();
				$('#activity-list').prepend( data );
				$('#activity-list :eq(0)').slideDown();
			},
			error: function( xhr, status, error ) {
				console.log( "Error saving new activity! status: " + status + " error: " + error );
				alert("Oops! Looks like we had an error saving your activity. Please try again.");
			}
		});
	},
	
	cancelNewActivity: function() {
		answer = confirm('Are you sure you want to cancel?');
		
		if (answer) {
			$('#new-activity').slideUp();
		}
	
		return false;
	}
}