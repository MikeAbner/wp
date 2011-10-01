WP = {
	
	Facebook: {
		afterFbInit: function(callback) {
			if(!window.fbApiInit) {
				setTimeout(function() { WP.Facebook.afterFbInit(callback); }, 50);
			} else {
				if(callback) {
					callback();
				}
			}
		},
	},
	
	initHomePage: function() {
		console.log('initHomePage');
		$('#fb-login').show();
		WP.Facebook.afterFbInit( function() {
			console.log('facebook should be inited now');
			FB.getLoginStatus(function(response) {
				console.log('getLoginStatus');
		  	if ( response.session ) {
					console.log('logged in');
					$.ajax({
				  	type: 'POST',
					  url: '/login',
					  data: 'uid=' + response.session.uid + '&access_token=' + response.session.access_token,
						headers: {
							'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
						},
					  success: function( data, status, xhr ) {
							console.log('success');
							$('nav p').fadeOut( 500, function() { $('#site-nav').fadeIn( 750 ); } );
						},
						error: function( xhr, status, error ) {
							console.log('error');
							alert('Uh oh! Looks like something broke.');
						}
					});
		  	}
				else {
					console.log('not logged in');
					$('#site-nav').fadeOut( 500, function() { $('nav p').fadeIn( 750 ); } );
					$('#fb-login').show();
					WP.subscribeToLoginEvent();
					$.ajax({
				  	type: 'POST',
					  url: '/logout',
						headers: {
							'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
						},
					  success: function( data, status, xhr ) {
							console.log('logged out successfully');
						},
						error: function( xhr, status, error ) {
							console.log('unable to logout');
							alert('Uh oh! Looks like something broke.');
						}
					});
		  	}
			});
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
					$('#fb-login').hide();
					$('nav p').fadeOut( 500, function() { $('#site-nav').fadeIn( 750 ); } );
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

		WP.Facebook.afterFbInit( function() {
			console.log('facebook should be inited now');
			FB.getLoginStatus(function(response) {
				console.log('getLoginStatus');
		  	if ( response.session ) {
					//logged in
		  	}
				else {
					console.log('not logged in');
					window.location = '/';
		  	}
			});
			
			//OPEN FRIEND PICKER
			$('#open-friend-picker-btn').overlay({
				mask: {
					color: '#191919',
					loadSpeed: 200,
					opacity: 0.9
				},
				closeOnClick: false,
				top: '15%',
				onLoad: function() {
					$('#friend-picker').jfmfs({
						pre_selected_friends: $('#activity_with').val().split(',')
					});
					$("#friend-picker").bind("jfmfs.selection.changed", function(e, data) { 
						WP.drawFriends( data );
					});
				}
			});
		});
		
		$("#when").dateinput({
			change: function() {
				var isoDate = this.getValue( 'yyyy-mm-dd' );
				$("#activity_when").val( isoDate );
			}
		});
		
		// ADD ACTIVITY
		$("#new-activity-btn a").click( function() {
			$('#new-activity').slideDown( 750 );
		});
		
		// SAVE ACTIVITY
		$('#save-activity-btn').click(function() {
			WP.saveNewActivity();
			return false;
		});
		
		//CANCEL NEW ACTIVITY
		$('#cancel-btn').click(function() {
			WP.cancelNewActivity();
			return false;
		});
		
		//CHOOSE FRIENDS
		$('#choose-friends-btn').live('click', function() {
			$('#open-friend-picker-btn').overlay().close();
			return false;
		});
		
		//CANCEL FRIENDS
		$('#cancel-friends-btn').live('click', function() {
			$('#open-friend-picker-btn').overlay().close();
			return false;
		});
		
		//DELETE ACTIVITY
		$('.delete-activity').live('click', function() {
			WP.deleteActivity( $.trim( $(this).parent().parent().find('.activity-id').text() ) );
			return false;
		});
		
		//SHOW MORE ACTIVITIES
		$('#show-more').click(function() {
			WP.showMoreActivities();
			return false;
		});
	},

	saveNewActivity: function() {
		$.ajax({
			type: 'POST',
			url: '/activities',
			data: $('#activity-form').serialize(),
			success: function( data, status, xhr ) {
				$('#activity-list').prepend( data );
				$('#new-activity').slideUp('slow', function() {
					setTimeout(function() { $('#activity-list :eq(0)').slideDown('slow'); }, 500);
					WP.clearNewActivityForm();
				});
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
			$('#new-activity').slideUp( 750 );
		}
	
		return false;
	},
	
	clearNewActivityForm: function() {
		$('#activity_what').val('');
		$('#when').val('');
		$('#activity_when').val('');
		$('#activity_at').val('');
		$('#activity_in').val('');
		$('#chosen-friends').html('');
		$('#activity_with').val('');
		$('#activity_desc').val('');
	},
	
	drawFriends: function( friends ) {
		chosenFriends = $('#chosen-friends').empty();
		$.each( friends, function( i, val ) {
			console.log(val)
			friend = $('#friend-picker #' + val['id']);
			html = "<a href='//www.facebook.com/" + val['id'] + "'>" + val['name'] + "</a>&nbsp;&nbsp;";
			chosenFriends.append( html );
			$('#activity_with').val( JSON.stringify( friends ) );
		});
	},
	
	chooseFriends: function() {
		$('#friend-picker-container').hide();
	},
	
	deleteActivity: function( id ) {
		answer = confirm('Are you sure you want to delete this activity?');
		
		if (answer) {
			$.ajax({
			  type: 'POST',
			  url: '/activities/' + id,
			  data: '_method=delete&authenticity_token=' + $('input[name="authenticity_token"]').val(),
				headers: {
					'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
				},
			  success: function( data, status, xhr ) {
					article = $('#activity_' + id)[0];
					article.slideUp('slow', function() {
						$(this).remove();
					});
				},
				error: function( xhr, status, error ) {
					alert('Uh oh! Looks like something broke.');
				}
			});
		}
	},
	
	showMoreActivities: function() {
		offset = $('article').length;
		
		$.ajax({
			type: 'GET',
			url: '/activities/more?offset=' + offset,
			headers: {
				'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
			},
		  success: function( data, status, xhr ) {
				$('#activity-list').append( data );
			},
			error: function( xhr, status, error ) {
				alert('Uh oh! Looks like something broke.');
			}
		});
	}
}