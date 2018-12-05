App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    // Load pets.
    $.getJSON('../pets.json', function(data) {
      var petsRow = $('#petsRow');
      var petTemplate = $('#petTemplate');

	  petTemplate.find('.btn-upload').attr('data-id', 0);

      for (i = 0; i < data.length; i ++) {
        petTemplate.find('.panel-title').text(data[i].name);
        petTemplate.find('img').attr('src', data[i].picture);
        petTemplate.find('.pet-breed').text(data[i].breed);
        petTemplate.find('.pet-age').text(data[i].age);
        petTemplate.find('.pet-location').text(data[i].location);
        petTemplate.find('.btn-adopt').attr('data-id', data[i].id);
		petTemplate.find('.pet-ownership').html("<br></br>"+data[i].ownership);	//cmjeong add
		//petTemplate.find('.pet-ownership').text('\n'+data[i].ownership);	

        petsRow.append(petTemplate.html());
      }
    });

    return App.initWeb3();
  },

  /*
  init: function() {
	  //Load pets
	  $.getJSON('../pets.json', function(data) {
		  var petsRow = $('#petsRow');
		  var petTemplate = $('#petTemplate');

		  console.log("cp0-pets", data);
		  for(i=0;i<data.length;i++) {
			  petTemplate.find('.panel-title').text(data[i].name);
			  petTemplate.find('img').attr('src', data[i].picture);
			  petTemplate.find('.pet-breed').text(data[i].breed);
			  petTemplate.find('.pet-age').text(data[i].age);
			  petTemplate.find('.pet-location').text(data[i].location);
			  petTemplate.find('btn-adopt').attr('data-id', data[i].id);

			  petsRow.append(petTemplate.html());
		  }
	  }
  }
  */

  initWeb3: function() {
    /*
     * Replace me...
     */
	  //Is there an injected web3 instance ?
	  if(typeof web3 !== 'undefined') {
		  App.web3Provider = web3.currentProvider;
	  } else {
		  //If no injected web3 instance is detected, fall back to Ganache
		  App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
	  }
	  web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    /*
     * Replace me...
     */
	  $.getJSON('Adoption.json', function(data) {
		  //Get the necessary contract artifact file and instantiate it with truffle-contract
		  var AdoptionArtifact = data;
		  App.contracts.Adoption = TruffleContract(AdoptionArtifact);

		  // Set the provider for our contract
		  App.contracts.Adoption.setProvider(App.web3Provider);

		  return App.markAdopted();
	  });

    return App.bindEvents();
  },

  bindEvents: function() {
	$(document).on('click', '.btn-upload', App.handleUpload);	// cmjeong create
    $(document).on('click', '.btn-adopt', App.handleAdopt);
  },

  markAdopted: function(adopters, account) {
    /*
     * Replace me...
     */
	  var adoptionInstance;

	  App.contracts.Adoption.deployed().then(function(instance) {
		  adoptionInstance = instance;

		  return adoptionInstance.getAdopters.call();
	  }).then(function(adopters) {
		  for(i=0;i<adopters.length;i++) {
			  if(adopters[i] !== '0x0000000000000000000000000000000000000000') {
				  $('.panel-pet').eq(i).find('button').text('Success').attr('disabled', true);
				  $('.pet-ownership').eq(i).html("<br></br>"+adopters[i]);	//cmjeong add
				  //$('.pet-ownership').eq(i).text(adopters[i]);
			  }
		  }
	  }).catch(function(err) {
		  console.log(err.message);
	  });
  },

  handleUpload: function(event) {
	  event.perventDefault();

  },

  handleAdopt: function(event) {
    event.preventDefault();

    var petId = parseInt($(event.target).data('id'));

    /*
     * Replace me...
     */

	var adoptionInstance;

	web3.eth.getAccounts(function(error, accounts) {
		if(error) {
			console.log(error);
		}

		var account = accounts[0];

		App.contracts.Adoption.deployed().then(function(instance) {
			adoptionInstance = instance;

			//Execute adopt as a transaction by sending account
			return adoptionInstance.adopt(petId, {from:account});
		}).then(function(result) {
			return App.markAdopted();
		}).catch(function(err) {
			console.log(err.message);
		});
	})
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
