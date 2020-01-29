import { TestBed } from '@angular/core/testing';

import { DummyService, IDummy } from '../base/dummy/index';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { environment } from 'src/environments/environment';

describe('Generic API Service', () => {
	const data: IDummy[] = [
		{
			id: 1,
			name: 'name1',
			parentId: 1,
			parentDescriptiveField: 'parent1',
		},
		{
			id: 2,
			name: 'name2',
			parentId: 1,
			parentDescriptiveField: 'parent1',
		}
	];

	const item: IDummy = data[0];
	const child = { id: 1, dummyId: 1 };

	let service: DummyService;
	let httpMock;
	let url: string = environment.apiUrl + '/dummy';

	beforeEach(() => {
		TestBed.configureTestingModule({
			imports: [HttpClientTestingModule]
		});

		service = TestBed.get(DummyService);
		httpMock = TestBed.get(HttpTestingController);
	});

	afterEach(() => {
		httpMock.verify();
	});

	it('should return single Dummy item against passed id', () => {
		service.getById(item.id).subscribe(response => {
			expect(response).toEqual(item);
		});

		const req = httpMock.expectOne(req => req.method === 'GET' && req.url === url + '/' + item.id);
		req.flush(item);
	});

	it('should return list of Dummy items', () => {
		service.getAll().subscribe(response => {
			expect(response).toEqual(data);
		});

		const req = httpMock.expectOne(req => req.method === 'GET' && req.url === url);
		req.flush(data);
	});

	it('should create item', () => {
		service.create(item).subscribe(response => {
			expect(response).toEqual(item);
		});

		const req = httpMock.expectOne(req => req.method === 'POST' && req.url === url);
		req.flush(item);
	});

	it('should update item', () => {
		service.update(item, item.id).subscribe(response => {
			expect(response).toEqual(item);
		});

		const req = httpMock.expectOne(req => req.method === 'PUT' && req.url === url + '/' + item.id);
		req.flush(item);
	});

	it('should delete item', () => {
		service.delete(item.id).subscribe(response => {
			expect(response).toEqual(null);
		});

		const req = httpMock.expectOne(req => req.method === 'DELETE' && req.url === url + '/' + item.id);
		req.flush(item);
	});

	it('should return list of associated items', () => {
		service.getAssociations('parent', 1).subscribe(response => {
			expect(response).toEqual(data);
		});

		const req = httpMock.expectOne(req => req.method === 'GET' && req.url === environment.apiUrl + "/parent/1/dummy");
		req.flush(data);
	});

	it('should return child item', () => {
		service.getChild('child', 1).subscribe(response => {
			expect(response).toEqual(child);
		});

		const req = httpMock.expectOne(req => req.method === 'GET' && req.url === url + "/1/child");
		req.flush(child);
	});

	it('should propagate error response in case of server side error', () => {
		service.getAll().subscribe(null, (errorMessage: any) => {
			expect(errorMessage.length).toBeGreaterThan(0);
		});

		const req = httpMock.expectOne(req => req.method === 'GET' && req.url === url);
		req.flush('Invalid request parameters', {
			status: 404,
			statusText: 'Bad Request'
		});
	});

	it('should propagate error response in case of client side error', () => {
		service.getAll().subscribe(null, (errorMessage: any) => {
			expect(errorMessage.length).toBeGreaterThan(0);
		});

		httpMock.expectOne(req => req.method === 'GET' && req.url === url).error(new ErrorEvent('network error'));
	});
});