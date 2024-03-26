import * as needle from 'needle';


const token = 'AT-2-0TOREXYGbxc6LSXmaep0BgeXrFN-j4GW';

const options= {
    headers: { 
       //'Authorization': 'Basic ' + Buffer.from('APIMClientId:ErT322hVLHzIi9Z5tbu58yzUvzVqlsh3T0tmKRV41bu004wqY664TM=' ).toString('base64')
        'Authorization': 'Basic ' + Buffer.from('TestIntrospect:foo' ).toString('base64')
     }
}
async function fetchProfile() {
     //needle.post('http://localhost/cas/oidc/profile',{token}, options, (err, resp)=> {   
      needle.post('http://localhost/cas/oidc/introspect',{ token }, options, (err, resp)=> {   

    console.log('resp?.body', resp?.body);
    
})
}

fetchProfile();
